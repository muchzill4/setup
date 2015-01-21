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
Plugin 'SirVer/ultisnips'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'takac/vim-hardtime'

" give more languages
Plugin 'othree/html5.vim'
Plugin 'kchmck/vim-coffee-script'
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
set ignorecase
set clipboard=unnamed
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
noremap <leader>r :make<cr>

" }}}
" MISC {{{

" show syntax highlighting groups for word under cursor
noremap <c-s-p> :call SynStack()<cr>
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
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" close omnicompletion preview popup
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

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
augroup END

" }}}
" PLUGIN SETTINGS {{{

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" hardtime
let g:hardtime_default_on = 1
let g:hardtime_ignore_quickfix = 1
