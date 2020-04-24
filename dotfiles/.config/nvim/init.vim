" PLUGINS {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug '/usr/local/opt/fzf'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf.vim'
Plug 'moll/vim-bbye'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'shime/vim-livedown'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'zhimsel/vim-stay'

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
set ts=2
set et
set sw=2
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
colorscheme mc4

" }}}
" BINDINGS {{{

let mapleader=','

" jump to previous letter match
nnoremap \ ,

" edit dotfiles
nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>ea :e ~/.config/alacritty/alacritty.yml<cr>
nnoremap <leader>ek :e ~/.config/kitty/kitty.conf<cr>
nnoremap <leader>ef :e ~/.config/fish/config.fish<cr>
nnoremap <leader>eg :e ~/.gitconfig<cr>
nnoremap <leader>et :e ~/.tmux.conf<cr>
nnoremap <leader>ec :e ~/.config/nvim/colors/mc4.vim<cr>

" copen
nnoremap <leader>c :copen<cr>

" save
nnoremap <leader>w :w!<cr>

" quit
nnoremap <leader>Q :q<cr>

" less annoyances
:command! W w
:command! Q q

" exit terminal insert
tmap <C-o> <C-\><C-n>

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

" vim-bbye {{{

nnoremap <leader>q :Bwipeout<cr>

" }}}
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
nmap <leader>s :Rg<space>
nmap <leader>S :Rg <C-R><C-W><cr>
nmap <leader>H :Helptags<cr>

" }}}
" coc.nvim {{{

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

let g:coc_global_extensions = ["coc-json", "coc-python", "coc-tsserver", "coc-css", "coc-prettier", "coc-tailwindcss"]

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

" }}}
" vim-commentary {{{

autocmd FileType jinja setlocal commentstring={#\ %s\ #}

" }}}

" }}}
