-- vim:foldmethod=marker

-- UTILS {{{ --
local cmd, fn = vim.api.nvim_command, vim.fn

local function build_map_opts(opts)
  local defaults = {noremap = true}
  if opts then
    return vim.tbl_extend('force', defaults, opts) 
  end
  return defaults
end

local function map(mode, lhs, rhs, opts)
  local options = build_map_opts(opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function bmap(bufnr, mode, lhs, rhs, opts)
  local options = build_map_opts(opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

local function opt(scope, key, value)
  vim[scope][key] = value
  if scope ~= 'o' then vim['o'][key] = value end
end
-- }}} --

-- PLUGINS {{{ --
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
cmd 'packadd packer.nvim'

require('packer').startup({{
  {'wbthomason/packer.nvim', opt = true},

  {'neovim/nvim-lspconfig'},
  {'ojroques/nvim-lspfuzzy'},
  {'nvim-treesitter/nvim-treesitter'},

  {'shougo/deoplete-lsp'},
  {'shougo/deoplete.nvim', run = ':UpdateRemotePlugins'},
  {'SirVer/ultisnips'},
  {'honza/vim-snippets'},

  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'bronson/vim-visual-star-search'},

  {'janko-m/vim-test'},
  {'tpope/vim-commentary'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-rhubarb'},
  {'tpope/vim-surround'},
  {'tpope/vim-unimpaired'},
  {'tpope/vim-vinegar'},
  {'ryvnf/readline.vim'},

  {'chriskempson/base16-vim'},
}})
-- }}} --

-- SETTINGS {{{ --
cmd 'colorscheme mc4'

local indent = 2
opt('bo', 'expandtab', true)
opt('bo', 'shiftwidth', indent)
opt('bo', 'tabstop', indent)
opt('o', 'clipboard', 'unnamed')
opt('o', 'completeopt', 'menuone,noinsert,noselect')
opt('o', 'hidden', true)
opt('o', 'ignorecase', true)
opt('o', 'mouse', 'a')
opt('o', 'scrolloff', 4)
opt('o', 'smartcase', true)
opt('o', 'termguicolors', false)
opt('o', 'updatetime', 200)
opt('wo', 'number', true)
opt('wo', 'relativenumber', true)
opt('wo', 'signcolumn', 'yes')
opt('wo', 'statusline', [[%<%f %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%) %P]])
-- }}} --

-- MAPS {{{ --
map('t', '<C-o>', '<C-\\><C-n>') -- to quit insert in terminal

map('n', '<leader>ev', ':e $MYVIMRC<CR>')
map('n', '<leader>ek', ':e ~/.config/kitty/kitty.conf<CR>')
map('n', '<leader>ef', ':e ~/.config/fish/config.fish<CR>')
map('n', '<leader>ec', ':e ~/.config/nvim/colors/mc4.vim<CR>')
-- }}} --

-- PLUGIN SETUP {{{ --
-- deoplete
vim.g['deoplete#enable_at_startup'] = 1

-- fzf
map('n', '<leader>f', ':Files<CR>')
map('n', '<leader>b', ':Buffers<CR>')
map('n', '<leader>c', ':Commits<CR>')
map('v', '<leader>s', [[:<C-u>call VisualStarSearchSet('/', 'raw')<CR>:Rg <C-r><C-/><cr>]])

-- vim-test
vim.g['test#strategy'] = 'neovim'
map('n', '<leader>tf', ':TestFile<CR>')
map('n', '<leader>tl', ':TestLast<CR>')
map('n', '<leader>ts', ':TestSuite<CR>')
map('n', '<leader>tt', ':TestNearest<CR>')

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true
  }
}
-- }}} --

-- MISC {{{ --
cmd 'au! BufWritePost init.lua :luafile %'
cmd 'au! BufWritePost mc4.vim :source %'
cmd 'au! TermOpen * startinsert'
cmd 'au! TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}'

-- Load local vim config
local local_config = os.getenv('LOCAL_VIM_CONFIG')
if local_config ~= nil then
  -- Is this horrible?
  cmd(':luafile '..local_config)
end
-- }}} --

-- LSP {{{ --
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>d', '<cmd>LspDiagnostics 0<CR>')

require('lspfuzzy').setup {}
local nvim_lsp = require('lspconfig')

nvim_lsp.jedi_language_server.setup {}
nvim_lsp.efm.setup {
  filetypes = {'python', 'markdown', 'yaml'}
}
--- }}} ---
