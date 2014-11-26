" | >>> VIM CONFIGURATION
" |
" | put together by muchzill4@gmail.com
" | thanks stevelosh(.com), you've helped me a lot
" |


" | >>> Vundle
" |
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'SirVer/ultisnips'
Plugin 'altercation/vim-colors-solarized'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'evanmiller/nginx-vim-syntax'
Plugin 'evidens/vim-twig'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'ingydotnet/yaml-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'mattn/emmet-vim'
Plugin 'moll/vim-bbye'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'rodjek/vim-puppet'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/vitality.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'wavded/vim-stylus'
call vundle#end()

runtime macros/matchit.vim
filetype plugin indent on


" | >> General
" |
set noswapfile
set history=1000
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set showbreak=↪
set hidden
set autowrite
set clipboard=unnamed
set tags+=.tags,.gemtags
set background=dark
set number
set statusline=%t\ %r%m%=%c,\%l/%L\ \ \ %P
set shell=/bin/sh " fish does not work well with vim
colorscheme abitoftron


" | >>> Bindings
" |
let mapleader=','

" Jump to previous letter match
nnoremap \ ,

" Open ctag in new window
nnoremap <c-\> <c-w>v<c-]>zvzz

" ,1 to underline, yay!
nnoremap <leader>1 yypwv$r-

" edit dotfiles
nnoremap <leader>ev :e $MYVIMRC<cr>

" uppercase, lowercase, camelcase
noremap <c-c>l viwu<esc>
noremap <c-c>u viwU<esc>
noremap <c-c>c bvU<esc>

" colon to space
nnoremap <space> :

" fast saving
nnoremap <leader>w :w!<cr>

" delete / change while in insert mode
inoremap <C-d> <esc>ddi
inoremap <C-c> <esc>cc

" quit
noremap <leader>q :q<cr>

" delete buffer
noremap <leader>d :Bdelete<cr>

" sane esc
inoremap jk <Esc>

" | >>> Helpers
" |

" show syntax highlighting groups for word under cursor
noremap <c-s-p> :call SynStack()<cr>
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

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

" save file on focus lost
augroup lost_focus
  au!
  au FocusLost * :silent! wall
augroup END

" Open help in vert split
augroup helpfiles
  au!
  au BufRead,BufEnter */doc/* wincmd L
augroup END

" Remove trailing whitespace
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    let _s=@/
    keepjumps :%s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Close omnicompletion preview popup
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif


" | >>> Plugin settings
" |
" >> EasyMotion
let g:EasyMotion_leader_key = '<leader>m'
let g:EasyMotion_do_shade = 1

" >> Ag
nnoremap <leader>a :Ag!<SPACE>

" >> CtrlP
let g:ctrlp_map = '<leader>t'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_use_caching = 0
let g:ctrlp_cmd = 'CtrlP'
noremap <leader>y :CtrlPBuffer<cr>

" >> UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" >> Synstastic
let g:syntastic_javascript_checkers = ['jsxhint']
let g:syntastic_error_symbol = "x"
let g:syntastic_warning_symbol = "!"
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
