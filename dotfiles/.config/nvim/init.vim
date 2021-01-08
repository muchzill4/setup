" PLUGINS {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'antoinemadec/coc-fzf'
Plug 'janko-m/vim-test'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'bronson/vim-visual-star-search'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'shime/vim-livedown', {'for': 'markdown'}
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'ryvnf/readline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

" Syntax
Plug 'yuezk/vim-js', { 'for': 'javascript' }
Plug 'vim-python/python-syntax', { 'for': 'python' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'jparise/vim-graphql'

call plug#end()

" }}}
" GENERAL {{{

set clipboard=unnamed
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮,trail:·
set noswapfile
set showbreak=↪
set tags+=.git/tags
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc
set ignorecase
set smartcase
set mouse=a
set tabstop=2
set expandtab
set shiftwidth=2
set viewoptions-=options,curdir
set gdefault
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_dirhistmax = 0
set undofile
set linebreak
set number
set splitbelow
set notermguicolors
set nocursorline
set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P
set shell=bash
colorscheme mc4

" }}}
" BINDINGS {{{

let mapleader=','

" jump to previous letter match
nnoremap \ ,

" edit dotfiles
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>ek :e ~/.config/kitty/kitty.conf<cr>
nnoremap <leader>ef :e ~/.config/fish/config.fish<cr>
nnoremap <leader>eg :e ~/.gitconfig<cr>
nnoremap <leader>ec :e ~/.config/nvim/colors/mc4.vim<cr>
nnoremap <leader>ed :e ~/.config/direnv/direnvrc<cr>

" copen
nnoremap <leader>co :copen<cr>

" save
nnoremap <leader>w :w!<cr>
:command! W w

" exit terminal insert
tmap <C-o> <C-\><C-n>

" kill buffers
nnoremap <leader>q :bdelete<cr>
nnoremap <leader>Q :%bd\|e#\|bd#<cr>

" }}}
" MISC {{{

" scale windows on resize
au VimResized * :wincmd =

" enter terminal-mode automatically
au TermOpen * startinsert

" load project specific config
if exists("$LOCAL_VIM_CONFIG")
  for path in split($LOCAL_VIM_CONFIG, ':')
    exec "source ".path
  endfor
endif

" reload config on modify
augroup reload_config
  au!
  au BufWritePost init.vim source %
  au BufWritePost mc4.vim source %
augroup END

" open help in vert split
augroup helpfiles
  au!
  au BufRead,BufEnter */doc/* wincmd L
augroup END

" }}}
" PLUGIN SETTINGS AND BINDINGS {{{

" vim-fugitive {{{

nmap <leader>gs :Gstatus<cr>
nmap <leader>gd :Gdiff<cr>
nmap <leader>gb :.Gbrowse<cr>
nmap <leader>gB :Gblame<cr>
nmap <leader>gl :Glog -- %<cr>
nmap <leader>gL :Glog --<cr>

" }}}
" vim-test {{{

let test#strategy = "neovim"
nmap <leader>tf :TestFile<cr>
nmap <leader>tl :TestLast<cr>
nmap <leader>ts :TestSuite<cr>
nmap <leader>tt :TestNearest<cr>

" }}}
" fzf.vim {{{

nmap <leader>B :Buffers<cr>
nmap <leader>F :Files<cr>
nmap <leader>T :Tags<cr>
nmap <leader>H :Helptags<cr>
nmap <leader>s :Rg<space>
nmap <leader>S :Rg <C-r><C-w><CR>
vmap <leader>S :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:Rg <C-r><C-/><CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

" }}}
" coc.nvim {{{

let g:coc_global_extensions = [
      \ "coc-json",
      \ "coc-python",
      \ "coc-css",
      \ "coc-prettier",
      \ "coc-tailwindcss",
      \ "coc-eslint",
      \ "coc-pairs",
      \]

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Mappings using coc-fzf
nnoremap <silent> <leader>cD :CocFzfList diagnostics<cr>
nnoremap <silent> <leader>cd :CocFzfList diagnostics --current-buf<cr>
nnoremap <silent> <leader>ce :CocFzfList extensions<cr>
nnoremap <silent> <leader>cc :CocFzfList commands<cr>
nnoremap <silent> <leader>ca :CocFzfList actions<cr>
xnoremap <silent> <leader>ca :CocAction<cr>

" }}}
" vim-commentary {{{

autocmd FileType jinja setlocal commentstring={#\ %s\ #}

" }}}
" python-syntax {{{

let g:python_highlight_all = 1

" }}}

" }}}
