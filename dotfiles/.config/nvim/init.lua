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
local install_path = fn.stdpath('data')..'/site/pack/paqs/opt/paq-nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone https://github.com/savq/paq-nvim.git '..install_path)
end

cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq {'savq/paq-nvim', opt = true}

paq {'bronson/vim-visual-star-search'}
paq {'janko-m/vim-test'}
paq {'junegunn/fzf'}
paq {'junegunn/fzf.vim'}
paq {'neovim/nvim-lspconfig'}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'ojroques/nvim-lspfuzzy'}
paq {'ryvnf/readline.vim'}
paq {'shougo/deoplete-lsp'}
paq {'shougo/deoplete.nvim', hook = fn['remote#host#UpdateRemotePlugins']}
paq {'tpope/vim-commentary'}
paq {'tpope/vim-fugitive'}
paq {'tpope/vim-rhubarb'}
paq {'tpope/vim-surround'}
paq {'tpope/vim-unimpaired'}
paq {'tpope/vim-vinegar'}
paq {'wbthomason/packer.nvim'}
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
opt('o', 'shell', 'zsh')
opt('o', 'smartcase', true)
opt('o', 'termguicolors', false)
opt('o', 'updatetime', 200)
opt('wo', 'number', true)
opt('wo', 'relativenumber', true)
opt('wo', 'signcolumn', 'yes')
opt('wo', 'statusline', [[%<%f %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%) %P]])
-- }}} --

-- MAPS {{{ --
map('t', '<C-[>', '<C-\\><C-n>') -- to quit insert in terminal

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
map('n', '<leader>s', ':Rg <C-r><C-w><CR>')
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
require('lspfuzzy').setup {}
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  bmap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bmap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bmap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bmap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bmap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bmap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  bmap(bufnr, 'n', '<space>c', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  bmap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  bmap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  bmap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
end

nvim_lsp.pyls_ms.setup {
	on_attach = on_attach,
	cmd = {
		'dotnet',
		'exec',
		fn.expand('~/Dev/vcs/python-language-server/output/bin/Debug/Microsoft.Python.LanguageServer.dll')
	}
}
--- }}} ---
