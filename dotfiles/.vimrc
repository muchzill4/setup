" MY VIM CONFIGURATION {{{
" ------------------------------
" Bartek Mucha
" <muchzill4@gmail.com>
" ------------------------------


" }}}
" VUNDLE {{{

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" give more functionality
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'tpope/vim-commentary'
Plugin 'muchzill4/vim-sensible'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kien/ctrlp.vim'
Plugin 'mtth/scratch.vim'

" give more languages
Plugin 'othree/html5.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()

filetype plugin indent on
runtime macros/matchit.vim

" }}}
" GENERAL {{{

set noswapfile
set undofile
set history=1000
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set showbreak=↪
set tabstop=8
set softtabstop=4
set shiftwidth=4
set tags+=.tags,.gemtags
set gdefault
set statusline=%t\ %r%m%=%c,\%l/%L\ \ \ %P
set foldenable
set wildmode=list:longest,full
set ignorecase
set clipboard=unnamed
set number
set mouse+=a
set ttymouse=xterm2
colorscheme abitoftron

" }}}
" BINDINGS {{{

let mapleader=','

" jump to previous letter match
nnoremap \ ,

" edit vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" fast saving
nnoremap <leader>w :w!<cr>

" sane esc
inoremap jk <Esc>

" make / run
nnoremap <leader>r :make<cr>

" }}}
" MISC {{{

" show syntax highlighting groups for word under cursor
nnoremap <c-s-p> :call SynStack()<cr>
function! SynStack()
    if !exists("*synstack")
	return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" remove trailing whitespace
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    let _s=@/
    keepjumps :%s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfun
augroup barber
    au!
    au BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END

" close omnicompletion preview popup
augroup close_preview
    au!
    au CompleteDone * if bufname("%") != "[Command Line]"|pclose|endif
augroup END

" }}}
" FILETYPES {{{

" reload config on modify
augroup w_config
    au!
    au BufWritePost .vimrc source %
augroup END

" reload colorscheme on save
augroup colorscheme_dev
    au!
    au BufWritePost abitoftron.vim color abitoftron
augroup END

" open help in vert split
augroup helpfiles
    au!
    au BufRead,BufEnter */doc/* wincmd L
augroup END

" common files
augroup commonfiles
    au!
    au FileType ruby,eruby setlocal st=2 ts=2 sw=2 expandtab
    au FileType javascript,coffee setlocal st=2 ts=2 sw=2 expandtab
    au FileType css,scss setlocal st=2 ts=2 sw=2 expandtab
    au FileType php,html setlocal st=4 ts=4 sw=4 expandtab
    au FileType vim setlocal foldmethod=marker

    au BufRead,BufNewFile *.scss set filetype=scss.css
augroup END

" }}}
" PLUGIN SETTINGS {{{

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" CtrlP
nnoremap <leader>t :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
let g:ctrlp_map = ""
let g:ctrlp_working_path_mode = ''
let g:ctrlp_switch_buffer = ''
if executable('ag')
    let g:ctrlp_use_caching = 0
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif
