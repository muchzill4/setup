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
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'vim-scripts/ag.vim'
Bundle 'vim-scripts/bufkill.vim'
Bundle 'othree/html5.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-commentary'
Bundle 'majutsushi/tagbar'
Bundle 'rodjek/vim-puppet'
Bundle 'kchmck/vim-coffee-script'
Bundle 'othree/javascript-libraries-syntax.vim'
Bundle 'pangloss/vim-javascript'
Bundle 'Shougo/neocomplete.vim'
Bundle 'Shougo/neosnippet.vim'
Bundle 'honza/vim-snippets'
Bundle 'ingydotnet/yaml-vim'
Bundle 'aliva/vim-fish'

 
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
set shiftround
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
set statusline=%f
set statusline+=\ %m
set statusline+=%=
set statusline+=%l
set statusline+=/
set statusline+=%L
set hidden
set cursorline
set nocursorcolumn
set formatoptions=qrn1
set autowrite
set clipboard=unnamed
set tags+=.tags,.gemtags

set re=1 " use old regex for ruby files sake
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
colorscheme TronZill4
syntax on
 
" Don't try to highlight lines longer than 800 characters.
set synmaxcol=800

" Cmon cursor
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
 
 
" | >>> Language/file specific
" |
augroup python_sets
    au!
    au FileType python setlocal
            \ softtabstop=4
            \ tabstop=4
            \ shiftwidth=4
            \ expandtab
            \ textwidth=80
            \ makeprg=python\ %
augroup END

augroup ruby_sets
    au!
    au FileType ruby setlocal
            \ softtabstop=2
            \ tabstop=2
            \ shiftwidth=2
            \ makeprg=ruby\ %
    au FileType ruby :DashKeywords ruby rails 
augroup END

augroup php_sets
    au!
    au FileType php setlocal
        \ makeprg=php\ -l\ %
    au FileType php :DashKeywords php
augroup END

augroup js_sets
    au!
    au FileType javascript setlocal
            \ softtabstop=2
            \ tabstop=2
            \ shiftwidth=2
            \ expandtab
            \ omnifunc=javascriptcomplete#CompleteJS
    au FileType php :DashKeywords javascript jquery 
augroup END


augroup html_sets
    au!
    au FileType html setlocal
            \ softtabstop=4
            \ tabstop=4
            \ shiftwidth=4
            \ expandtab
            \ omnifunc=htmlcomplete#CompleteTags
augroup END

augroup css_sets
    au!
    au FileType css,scss setlocal
            \ softtabstop=2
            \ tabstop=2
            \ shiftwidth=2
            \ expandtab
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
nnoremap <leader>ez :e ~/.zshrc<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>
 
" smarter way to move btw. windows (ctrl+<x>)
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
 
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
 
" run current file aka make
noremap <leader>r :make<cr>
 
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
    au BufWritePost notsobadwolf.vim color notsobadwolf
    au BufWritePost notsomidnight.vim color notsomidnight
    au BufWritePost lettherebelight.vim color lettherebelight
    au BufWritePost TronZill4.vim color TronZill4
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

" | >>> Plugin settings
" |

" >> NERDTree
noremap <silent> <leader>n :NERDTreeToggle<cr>
let NERDTreeIgnore          = ['\.png$', '\.jpg$', '\.gif$'] " Don't show image files.
let NERDTreeBookmarksFile   = '/Users/much4/.vim/tmp/NERDTreeBookmarks'
let NERDTreeChDirMode       = 1
let NERDTreeShowBookmarks   = 1
let NERDTreeShowLineNumbers = 0
 
" >> EasyMotion
let g:EasyMotion_leader_key = '<leader>m'
let g:EasyMotion_do_shade = 1

" >> CtrlP
let g:ctrlp_map = '<leader>t'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_max_height = 10
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/](tmp)$',
    \ }
noremap <leader>y :CtrlPBuffer<cr>
 
" >> Ack
nnoremap <leader>a :Ag!<space>
let g:agprg = 'ag --nogroup --nocolor --column'
 
" >> Dash
nmap <leader>d <Plug>DashSearch
nmap <leader>D <Plug>DashGlobalSearch

" >> Neocomplete
let g:neocomplete#max_list = 5
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" >> Neosnippet
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

imap <C-j> <Plug>(neosnippet_expand_or_jump)
smap <C-j> <Plug>(neosnippet_expand_or_jump)
xmap <C-j> <Plug>(neosnippet_expand_target)
