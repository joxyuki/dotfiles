" editing and saveing settings
set autowrite
set nobackup
if has('wind32') || has('win64')
    set undodir=$HOME/.vim/undo  " undo file directory (kaoriya only)
endif
set clipboard+=unnamed
set hidden              " enable buffer
set switchbuf+=useopen

" file encoding settings (windows only)
if has('win32') || has('win64')
    set fileencodings=iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,ucs-bom,euc-jp,eucjp-ms,cp932,latin1   " encoding for reading
    set fileformats=dos,unix,mac
endif
set modeline            " enable modeline

set list                " visible <Tab> and other invisible chars
set listchars=tab:>-,trail:-,extends:#,nbsp:-
set textwidth=72        " max length of a line
set tabstop=8           " number of spaces when displaying <Tab>
set expandtab           " input spaces instead of <Tab>
set shiftwidth=4        " number of spaces when inputting <Tab> automatically
set softtabstop=4       " number of speces when inputting or deleting <Tab>
set backspace=2
"set whichwrap=4
set foldmethod=indent

set showmatch           " hilight "(" when ")" is input
set scrolloff=5

" status line and related settings
set laststatus=2        " always displays status line
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set number

" search setting
set ignorecase
set smartcase
set wrapscan
set hlsearch

" maps
nnoremap <C-c><C-c> :<C-u>nohlsearch<CR><Esc>
nnoremap qq: <Esc>q:
nnoremap qq/ <Esc>q/

nnoremap ;; 5j
nnoremap :: :!
nnoremap zi zizz

nnoremap g// I//<ESC>
nnoremap g/* O/*<ESC>
nnoremap g*/ o*/<ESC>
nnoremap g3 I#<ESC>
nnoremap g5 I%<ESC>
nnoremap g2 I"<ESC>
nnoremap gcc :!gcc
nnoremap g++ :!g++

nnoremap Q <Nop>
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" only for neovim
if has('nvim')
    tnoremap <silent> <ESC> <C-\><C-n> " terminal emulator 
endif

"-- plugin settings --
"
"----------
" dein.vim
"----------
if &compatible
    set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
    call dein#begin('~/.cache/dein')

    let s:toml_dir = '~/.config/nvim/dein/'
    call dein#load_toml(s:toml_dir . 'dein.toml')
    if has('nvim')
        call dein#load_toml(s:toml_dir . 'dein_nvim.toml')
    endif

    " Required:
    call dein#end()
    call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable
colorscheme molokai

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"-- End dein -- 

"-----------
" unite.vim
"-----------
let g:unite_enable_start_insert=0
let g:unite_source_histroy_yank_enable=1
let g:unite_source_file_mru_limit=50 

nnoremap [unite] <Nop>
nmap <Space>u [unite]

nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
"nnoremap <silent> [unite]t :<C-u>Unite buffer_tab<CR>
nnoremap <silent> [unite]f :<C-u>Unite file<CR>
nnoremap <silent> [unite]r :<C-u>Unite file_rec<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]o :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]l :<C-u>Unite line<CR>
"nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>

"-- End unite -- 

" -- end of plugin settings --

