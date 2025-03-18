#!/bin/bash

set -Ceu

function usage() {
    cat << EOT
Usage:
    $0 [OPTIONS]

Options:
    -t  Test mode. Just output commands but do not make links.
    -f  Force overwrite existing files (default is interctive).
    -h  Show this help message.
EOT
}

function get_os() {
    if [ "$(uname)" == "Darwin" ]; then
        OS="mac"
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        if [ -e /etc/debian_version ] || [ -e /etc/debian_release ]
        then
            if [ -e /etc/lsb-release ]; then
                OS="ubuntu"
            else
                OS="debian"
            fi
        elif [ -e /etc/redhat-release ]; then
            if [ -e /etc/centos-release ]; then
                OS="centos"
            elif [ -e /etc/oracle-release ]; then
                OS="oracle"
            else
                OS="redhat"
            fi
        else
            OS="linux"
        fi
    else
        echo "Your platform ($(uname -a)) is no supported."
        exit 1
    fi
}

function get_script_dir() {
    if [ -L $0 ]; then
        echo "Please run physical file (not link)."
        exit 1
    fi
    readonly SCR_DIR=$(cd $(dirname $0) && pwd)
}

# log output syntax presetting
msg=""
tred=$(tput setaf 1)
tgreen=$(tput setaf 2)
tyellow=$(tput setaf 3)
treset=$(tput sgr0)

function log() {
    local level=${1}
    local _msg=""
    if [ $# -gt 2 ]; then
        _msg=${2}
    else
        _msg=${msg}
    fi

    if [ "${level}" == "DEBUG" ]; then
        if ${DEBUG}; then
            echo "(DEBUG)   ${_msg}"
        fi
    elif [ "${level}" == "INFO" ]; then
        echo "${tgreen}(INFO)${treset}    $_msg"
    elif [ "${level}" == "WARNING" ]; then
        echo "${tyellow}(WARNING)${treset} ${_msg}"
    elif [ "${level}" == "ERROR" ]; then
        echo "${tred}(ERROR)${treset}   ${_msg}"
    fi
}

OS=""
TEST_MODE="false"
LN_OPT="-snvi"

get_os
get_script_dir

cd ${SCR_DIR}

while getopts tfh OPT
do
    case ${OPT} in
        t) TEST_MODE=true ;;
        f) LN_OPT=${LN_OPT/i/}; LN_OPT+='f' ;;
        h) usage; exit 0 ;;
        \?) usage; exit 1 ;;
    esac
done

msg="Installing dotfiles..."
log INFO

# shell
case "${OS}" in
    "ubuntu") SRC="shell/bashrc.ubuntu"; LN_NAME=".bash_aliases" ;;
    "centos" | "redhat") SRC="shell/bashrc.centos"; LN_NAME=".bashrc" ;;
    "mac") SRC="shell/zhrc"; LN_NAME=".zshrc";;
esac
if [ -n $LN_NAME ]; then
    if ${TEST_MODE}; then
        msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/${SRC} ~/${LN_NAME}"
        log INFO
    else
        ln ${LN_OPT} ${SCR_DIR}/${SRC} ~/${LN_NAME}
    fi
else
    msg="Skipp .bashrc/.zshrc your platform is not suppoted."
    log WARNING
fi

# tmux
if type "tmux" > /dev/null 2>&1; then
    if ${TEST_MODE}; then
        msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/tmux/tmux.conf ~/.tmux.conf"
        log INFO
    else
        ln ${LN_OPT} ${SCR_DIR}/tmux/tmux.confi ~/.tmux.conf
    fi
else
    msg="tmux is not installed. Skipping."
    log INFO
fi

# git
if type "git" > /dev/null 2>&1; then
    if ${TEST_MODE}; then
        msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/git/gitconfig ~/.gitconfig"
        log INFO
    else
        ln ${LN_OPT} ${SCR_DIR}/git/gitconfig ~/.gitconfig
    fi
else
    msg="git is not installed. Skipping."
    log INFO
fi

# vim
if which -a vim | grep -v alias > /dev/null 2>&1; then
    if ${TEST_MODE}; then
        msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/vim/vimrc ~/.vimrc"
        log INFO
    else
        ln ${LN_OPT} ${SCR_DIR}/vim/vimrc ~/.vimrc
    fi
else
    msg="Vim is not installed. Skipping."
    log INFO
fi

# neovim
if type "nvim" > /dev/null 2>&1; then
    if [ ! -e ~/.config ]; then
        if ${TEST_MODE}; then
            msg="(test mode) mkdir ~/.config"
            log INFO
        else
            msg="mkdir ~/.config"
            log INFO
            mkdir ~/.config
        fi
    fi

    if ${TEST_MODE}; then
        msg="(test mode) ln ${LN_OPT} ${SCR_DIR}/nvim ~/.config/nvim"
        log INFO
    else
        ln ${LN_OPT} ${SCR_DIR}/nvim ~/.config/nvim
    fi
else
    msg="Neovim is not installed. Skipping."
    log INFO
fi

msg="Completed!"
log INFO
