" | >>> VIM CONFIGURATION
" |
" | put together by muchzill4@gmail.com
" | thanks stevelosh(.com), you've helped me a lot
" |


" | >>> Vundle
" |
filetype off
set nocompatible
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-scripts/ag.vim'
Bundle 'othree/html5.vim'
Bundle 'tpope/vim-vinegar'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-commentary'
Bundle 'rodjek/vim-puppet'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'
Bundle 'ingydotnet/yaml-vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'evanmiller/nginx-vim-syntax'
Bundle 'altercation/vim-colors-solarized'
Bundle 'mattn/emmet-vim'
Bundle 'evidens/vim-twig'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'sjl/vitality.vim'
Bundle 'christoomey/vim-tmux-navigator'


" | >>> Backup & Undo
" |
set nowb
set nobk
set noswapfile

set undofile
set undoreload=10000

set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//

" If above are not there yet, create'em!
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif


" | >> Searching
" |
set ignorecase " ignore case in search patterns
set smartcase  " only if using lowercase letters
set gdefault


" | >> Indenting
" |
set noshiftround
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent


" | >> General
" |
set encoding=utf-8
set modelines=0
set history=100
set showmode
set showcmd
set number
set numberwidth=4
set wrap
set linebreak
set noruler
set colorcolumn=0
set textwidth=0
set laststatus=2
set visualbell
set t_vb=
set hls
set incsearch
set autoread " reload files that have been updated outside vim
set showmatch
set matchpairs+=<:>
set scrolloff=3
set splitbelow
set splitright
set lazyredraw
set ttyfast
set title
set notimeout
set ttimeout
set ttimeoutlen=10
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set showbreak=↪
set matchtime=3
set statusline=%f\ %r[%{(&fenc==\"\"?&enc:&fenc)}]\ %=%m\ %l/%L
set hidden
set cursorline
set nocursorcolumn
set formatoptions=qrn1
set autowrite
set clipboard=unnamed
set tags+=.tags,.gemtags
set backspace=2 " make backspace work like most other apps
set shell=/bin/sh " fish does not work well with vim

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*


" | Ignoring Files
" |
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.ico,*.ai,*.psd,*.ttf,*.svg
set wildignore+=*.ttf,*.woff,*.eof
set wildignore+=*.DS_Store


" | >>> Gui options
" |
if has('gui_running')
  set guifont=Terminus\ (TTF):h12
  set noantialias

  set linespace=1
  set transparency=0

  " disable blinking
  set guicursor+=a:blinkon0

  " remove gui clutter
  set go-=l
  set go-=L
  set go-=r
  set go-=R
  set go-=T
  set go-=e

  " Full screen means FULL screen
  set fuoptions=maxvert,maxhorz
end


" | >>> Syntax
" |

colorscheme solarized
let g:solarized_visibility = "low"
let g:solarized_italic = 0
set background=dark
syntax on

" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800


" | >>> Language/file specific
" |
augroup python_sets
    au!
    au FileType python setlocal
        \ softtabstop=4
        \ tabstop=4
        \ shiftwidth=4
        \ textwidth=79
        \ colorcolumn=79
        \ makeprg=python\ %
        \ commentstring=#%s
augroup END

augroup ruby_sets
    au!
    au BufNewFile,BufRead Vagrantfile set filetype=ruby
    au FileType ruby setlocal
        \ textwidth=79
        \ colorcolumn=79
        \ makeprg=ruby\ %
        \ omnifunc=rubycomplete#Complete
        \ commentstring=#%s
augroup END

augroup php_sets
    au!
    au FileType php setlocal
        \ softtabstop=4
        \ tabstop=4
        \ shiftwidth=4
        \ makeprg=php\ -l\ %
        \ omnifunc=phpcomplete#CompletePHP
augroup END

augroup js_sets
    au!
    au BufNewFile,BufRead Gruntfile set filetype=javascript
    au FileType javascript setlocal
        \ omnifunc=javascriptcomplete#CompleteJS
        \ makeprg=node\ %
        \ commentstring=//%s
augroup END


augroup html_sets
    au!
    au FileType html setlocal
        \ softtabstop=4
        \ tabstop=4
        \ shiftwidth=4
        \ omnifunc=htmlcomplete#CompleteTags
augroup END

augroup css_sets
    au!
    au FileType css,scss setlocal
        \ omnifunc=csscomplete#CompleteCSS
augroup END


" | >>> Bindings
" |
let mapleader=','

" Jump to previous letter match
nnoremap \ ,

" Open ctag in new window
nnoremap <c-\> <c-w>v<c-]>zvzz

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" ESC
inoremap jk <esc>

" ,1 to underline, yay!
nnoremap <leader>1 yypwv$r-

" edit dotfiles
nnoremap <leader>ev :e $MYVIMRC<cr>

" uppercase, lowercase, camelcase
noremap <c-c>l viwu<esc>
noremap <c-c>u viwU<esc>
noremap <c-c>c bvU<esc>

" fullscreen
inoremap <F1> <ESC>:set invfullscreen<CR>a
noremap <F1> :set invfullscreen<cr>

" temp remove search hl
nnoremap <F12> :set hlsearch!<cr>

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
noremap <leader>d :bdelete<cr>

" run current file aka make
function! ClearAndMake()
  silent !clear
  execute 'make!'
endfunc

noremap <leader>r :call ClearAndMake()<cr>


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

" save file on focus lost
augroup lost_focus
  au!
  au FocusLost * :silent! wall
augroup END

" return to the same line when you reopen a file
" Thanks, Amit & SLJ
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Open help in vert split
augroup helpfiles
  au!
  au BufRead,BufEnter */doc/* wincmd L
augroup END

" Remove trailing whitespace (don't use on binary! :D)
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    let _s=@/
    keepjumps :%s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


" | >>> Plugin settings
" |

" >> EasyMotion
let g:EasyMotion_leader_key = '<leader>m'
let g:EasyMotion_do_shade = 1

" >> The silver searcher
nnoremap <leader>a :Ag!<space>
let g:agprg = 'ag --nogroup --nocolor --column -U'

" >> CtrlP
let g:ctrlp_map = '<leader>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_max_height = 10
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](tmp)$',
    \ }
noremap <leader>y :CtrlPBuffer<cr>
