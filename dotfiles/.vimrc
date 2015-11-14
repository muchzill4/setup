" MY VIM CONFIGURATION {{{
"
"
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
Plugin 'janko-m/vim-test'
Plugin 'kien/ctrlp.vim'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'nelstrom/vim-qargs'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-rsi'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-vinegar'
Plugin 'junegunn/goyo.vim'

" give more languages
Plugin 'groenewege/vim-less'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'othree/html5.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'mxw/vim-jsx'

call vundle#end()

filetype plugin indent on

" }}}
" GENERAL {{{

set clipboard=unnamed
set gdefault
set ignorecase
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set nofoldenable
set noswapfile
set number
set shiftwidth=4
set showbreak=↪
set softtabstop=4
set statusline=%<%f\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set tabstop=8
set tags+=.tags,.gemtags
set wildmode=list:longest,full
set undodir=~/.vim/tmp/undo/
set undofile
set nocursorline
set linebreak
set mouse=a
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
colorscheme abitoftron

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

" bdelete
nnoremap <leader>d :bd<cr>

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

" Fugitive
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gl :Glog -- %<cr>

" CtrlP
nnoremap <leader>t :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>
nnoremap <leader>T :CtrlPTag<cr>
let g:ctrlp_map = ''
let g:ctrlp_working_path_mode = ''
let g:ctrlp_switch_buffer = ''
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" Test
nmap <silent> <leader>R :TestNearest<cr>
nmap <silent> <leader>r :TestFile<cr>
nmap <silent> <leader>a :TestSuite<cr>
nmap <silent> <leader>l :TestLast<cr>
nmap <silent> <leader>g :TestVisit<cr>

let test#javascript#jasmine#executable = 'jasmine'
let test#ruby#rspec#executable = 'spring rspec' " meh
