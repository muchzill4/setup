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

" Give more functionality
Plugin 'gmarik/Vundle.vim'
Plugin 'SirVer/ultisnips'
Plugin 'godlygeek/tabular'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-unimpaired'
Plugin 'marijnh/tern_for_vim'

" Give more languages
Plugin 'wavded/vim-stylus'
Plugin 'evidens/vim-twig'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'vim-ruby/vim-ruby'

call vundle#end()

filetype plugin indent on
runtime macros/matchit.vim


" | >> General
" |
set undofile
set history=1000
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set showbreak=↪
set tags+=.tags,.gemtags
set number
set gdefault
set statusline=%t\ %r%m%=%c,\%l/%L\ \ \ %P
set foldenable
set shell=/bin/sh " fish does not work well with vim
colorscheme abitoftron


" | >>> Bindings
" |
let mapleader=','

" Jump to previous letter match
nnoremap \ ,

" edit vimrc
nnoremap <leader>ev :e $MYVIMRC<cr>

" fast saving
nnoremap <leader>w :w!<cr>

" quit
noremap <leader>q :q<cr>

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
