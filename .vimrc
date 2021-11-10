" editing and saveing settings
set autowrite
set nobackup
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
"set foldmethod=indent

set showmatch           " hilight when "(" and ")" is input
set spelllang=en,cjk
set scrolloff=5

set splitright

" file type indent settings
augroup fileTypeIndentAug
    autocmd!
    autocmd BufNewFile,BufRead *.{yml,yaml} setlocal ts=2 sw=2 sts=2
augroup END

" status line and related settings
set laststatus=2        " always displays status line
set number

" search setting
set ignorecase
set smartcase
set wrapscan
set hlsearch

" vimgrep
augroup vimgrepAug
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

" diff setting
set diffopt=filler,vertical
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
            \ | diffthis | wincmd p | diffthis
endif

" maps
nnoremap <C-c><C-c> :<C-u>nohlsearch<CR><Esc>
nnoremap qq: <Esc>q:
nnoremap qq/ <Esc>q/

nnoremap ;; 5j
nnoremap :: :!
nnoremap zi zizz

nnoremap g// I// <ESC>
nnoremap g/* O/* <ESC>
nnoremap g*/ o */<ESC>
nnoremap g3 I# <ESC>
nnoremap g5 I% <ESC>
nnoremap g2 I" <ESC>

nnoremap Q <Nop>
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" only for neovim
if has('nvim')
    tnoremap <silent> <ESC> <C-\><C-n>  " terminal emulator
    if has('win32') || has('win64')
        let g:python3_host_prog =
            \'~\AppData\Local\Programs\Python\Python38-32\python.exe'
    else
        let g:python3_host_prog = system('echo -n `which python3`')
    endif
endif

"---------------------
"   plugin settings   
"---------------------

"----------
" dein.vim
"----------
if has('nvim') || v:version >= 800
    if has('win32') || has('win64')
        let s:dein_dir = '~/AppData/Local/dein'
        let s:toml_dir = '~/AppData/Local/nvim/dein/'
    else
        let s:dein_dir = '~/.cache/dein'
        let s:toml_dir = '~/.config/nvim/dein/'
    endif

    " Required:
    let &runtimepath = &runtimepath . ',' . s:dein_dir
                     \ . '/repos/github.com/Shougo/dein.vim'

    " Required:
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)

        call dein#load_toml(s:toml_dir . 'dein.toml')
        if has('nvim')
            call dein#load_toml(s:toml_dir . 'dein_nvim.toml')
        endif

        " Required:
        call dein#end()
        call dein#save_state()
    endif

    " If you want to install not installed plugins on startup.
    if dein#check_install()
        call dein#install()
    endif

    " Required:
    filetype plugin indent on
    syntax enable
    colorscheme molokai
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NonText ctermbg=NONE guibg=NONE
    highlight LineNr ctermbg=NONE guibg=NONE
    highlight Folded ctermbg=NONE guibg=NONE
    highlight EndOfBuffer ctermbg=NONE guibg=NONE
endif

"-------------
" denite.nvim
"-------------
if (has('nvim-0.4.0') || v:version >= 800) && has('python3')
    augroup deniteAug
        autocmd!
        autocmd FileType denite call s:denite_my_settings()
        function! s:denite_my_settings() abort
            set winblend=30
            nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
            nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
            nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
            nnoremap <silent><buffer><expr> q denite#do_map('quit')
            nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
            nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select').'j'
        endfunction

        autocmd FileType denite-filter call s:denite_filter_my_settings()
        function! s:denite_filter_my_settings() abort
            set winblend=10
            imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
        endfunction
    augroup END

    if has('win32') || has('win64')
        " Change file/rec command.
        call denite#custom#var('file/rec', 'command', ['scantree.py', '--ignore',
                             \ '.git', '--path', ':directory'])
    else
        call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor',
                             \ '--nogroup', '--hidden', '-U', '--ignore', '.git',
                             \ '-g', ''])
    endif

    let s:denite_win_width_percent = 0.7
    let s:denite_win_height_percent = 0.7
    call denite#custom#option('default', {
        \ 'split': 'floating',
        \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
        \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 1.2),
        \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
        \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
        \ 'prompt': '> ', })

    nnoremap [Denite] <Nop>
    nmap <Space>d [Denite]
    nnoremap <silent> [Denite]b :<C-u>Denite buffer<CR>
    nnoremap <silent> [Denite]f :<C-u>Denite file/rec<CR>
    nnoremap <silent> [Denite]m :<C-u>Denite file_mru<CR>
    nnoremap <silent> [Denite]l :<C-u>Denite line<CR>
    nnoremap <silent> [Denite]g :<C-u>Denite grep<CR>
endif

"----------
" deoplete
" ---------
if has('nvim') || v:version >= 800
    let g:deoplete#enable_at_startup = 1
endif

"-----------
" syntastic
"-----------
if ! has('win32') && ! has('win64')
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntatic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 0
    let g:syntastic_check_on_wq = 0
    let g:syntastic_python_checkers = ['flake8']
    let g:syntastic_python_flake8_args =
      \ "--ignore E128,N320,I100,I201,D100,D101,D102,D103"
endif

"-----------
" lightline
"-----------
let g:lightline = {
    \ 'colorscheme' : 'wombat',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head'
    \ },
    \ }

"----------
" fugitive
"----------
nnoremap [fugitive] <Nop>
nmap <Space>g [fugitive]
nnoremap [fugitive]s :<C-u>Gstatus<CR><C-w>T:help fugitive_c<CR><C-w><C-w>
nnoremap [fugitive]a :<C-u>Gwrite<CR>
nnoremap [fugitive]w :<C-u>Gwq<CR>
nnoremap [fugitive]c :<C-u>Gcommit<CR>
nnoremap [fugitive]m :<C-u>Gcommit --amend<CR>
nnoremap [fugitive]d :<C-u>Gdiff<CR>
nnoremap [fugitive]b :<C-u>Gblame<CR>
nnoremap [fugitive]r :<C-u>Gread<CR>
nnoremap [fugitive]g :<C-u>Ggrep

"--------
" previm
"--------
if has('mac')
    let g:previm_open_cmd='open /Applications/Google\ Chrome.app/'
    augroup PrevimAug
        autocmd!
        autocmd BufNewFile,BufRead *.{md,markdown} set filetype=markdown
    augroup END
endif

" -- end of plugin settings --

