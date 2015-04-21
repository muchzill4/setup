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

Plugin 'gmarik/Vundle.vim'

" give more functionality
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'kien/ctrlp.vim'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rsi'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'skalnik/vim-vroom'

" give more languages
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'kchmck/vim-coffee-script'
Plugin 'othree/html5.vim'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()

filetype plugin indent on
runtime macros/matchit.vim

" }}}
" GENERAL {{{

set noswapfile
set history=1000
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set showbreak=↪
set tabstop=8
set softtabstop=4
set shiftwidth=4
set tags+=.tags,.gemtags
set gdefault
set number
set statusline=%f\ %h%m%r
set statusline+=%=
set statusline+=%{GitStatusline()}\ %c,\%l/%L\ %P
set wildmode=list:longest,full
set ignorecase
set nofoldenable
set clipboard=unnamed
set mouse+=a
set ttymouse=xterm
colorscheme abitoftron
set undofile
set undodir=~/.vim/tmp/undo/
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif

" }}}
" BINDINGS {{{

let mapleader=','

" jump to previous letter match
nnoremap \ ,

" edit dotfiles
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>eb :e ~/.bash_profile<cr>
nnoremap <leader>ea :e ~/.bash/aliases.bash<cr>
nnoremap <leader>ep :e ~/.bash/prompt.bash<cr>
nnoremap <leader>eg :e ~/.gitconfig<cr>

" copen
nnoremap <leader>c :copen<cr>

" fast saving
nnoremap <leader>w :w!<cr>

" sane esc
inoremap jk <Esc>

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
" PLUGIN SETTINGS AND BINDINGS {{{

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" CtrlP
nnoremap <leader>t :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>T :CtrlPTag<cr>
let g:ctrlp_map = ""
let g:ctrlp_working_path_mode = ''
let g:ctrlp_switch_buffer = ''
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" Fugitive
function! GitStatusline()
    if !exists('b:git_dir')
	return ''
    endif
    return '['.fugitive#head(7).']'
endfunction
nnoremap <leader>g :Gstatus<cr>
