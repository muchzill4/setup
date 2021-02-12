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
  {'Vimjas/vim-python-pep8-indent'},

  {'shougo/deoplete-lsp'},
  {'shougo/deoplete.nvim', run = ':UpdateRemotePlugins'},
  {'Shougo/neosnippet.vim'},
  {'Shougo/neosnippet-snippets'},

  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'bronson/vim-visual-star-search'},

  {'janko-m/vim-test'},
  {'tartansandal/vim-compiler-pytest'},
  {'tpope/vim-commentary'},
  {'tpope/vim-dispatch'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-obsession'},
  {'tpope/vim-rhubarb'},
  {'tpope/vim-surround'},
  {'tpope/vim-unimpaired'},
  {'tpope/vim-vinegar'},
  {'ryvnf/readline.vim'},
  {'Yggdroot/indentLine'},
}})
-- }}} --

-- SETTINGS {{{ --
cmd 'colorscheme mc4'

local indent = 2
vim.o.expandtab = true
vim.o.shiftwidth = indent
vim.o.tabstop = indent
vim.o.clipboard = 'unnamed'
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.mouse = 'a'
vim.o.scrolloff = 4
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
local statusline = table.concat({
  '%<%f %h%m%r',
  '%=',
  '%l:%c',
  '%{ObsessionStatus(" $ ", " S ")}',
  '%1*',
  [[%{luaeval("require('statusline').branch_name()")}]],
  '%2*',
  [[%{luaeval("require('statusline').diag_count('Error')")}]],
  '%3*',
  [[%{luaeval("require('statusline').diag_count('Warning')")}]],
  '%4*',
  [[%{luaeval("require('statusline').diag_count('Info')")}]],
})
vim.o.statusline = statusline
vim.o.termguicolors = true
vim.o.updatetime = 200
vim.o.wildmode = 'longest:full,full'
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
-- }}} --

-- MAPS {{{ --
map('n', '<space>', '<Nop>')
vim.g.mapleader = ' '
map('t', '<C-o>', '<C-\\><C-n>') -- to quit insert in terminal

map('n', '<leader>ev', ':e $MYVIMRC<CR>')
map('n', '<leader>ek', ':e ~/.config/kitty/kitty.conf<CR>')
map('n', '<leader>ef', ':e ~/.config/fish/config.fish<CR>')
map('n', '<leader>ec', ':e ~/.config/nvim/lua/mc4.lua<CR>')
-- }}} --

-- PLUGIN SETUP {{{ --
-- deoplete
vim.g['deoplete#enable_at_startup'] = 1

-- neosnippet
map('i', '<C-j>', '<Plug>(neosnippet_expand_or_jump)', { noremap = false })
map('s', '<C-j>', '<Plug>(neosnippet_expand_or_jump)', { noremap = false })
map('x', '<C-j>', '<Plug>(neosnippet_expand_target)', { noremap = false })
vim.g['neosnippet#snippets_directory'] = fn.stdpath('config')..'/snips'

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
cmd 'au! BufWritePost mc4.lua :luafile %'
cmd 'au! TermOpen * startinsert'
cmd 'au! TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}'
cmd 'command! W w'

-- Python
vim.g.python3_host_prog = os.getenv('HOME')..'/.venvs/neovim3/bin/python'

-- Load local vim config
local local_config = os.getenv('LOCAL_VIM_CONFIG')
if local_config ~= nil then
  -- Is this horrible?
  cmd(':luafile '..local_config)
end
-- }}} --

-- LSP {{{ --
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
  }
)

local function on_attach(client, bufnr)
  local function cur_bmap(mode, lhs, rhs, opts)
    bmap(bufnr, mode, lhs, rhs, opts)
  end

  cur_bmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  cur_bmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  cur_bmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  cur_bmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  cur_bmap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  cur_bmap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
  cur_bmap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  cur_bmap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  cur_bmap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  cur_bmap('n', '<leader>ld', '<cmd>LspDiagnostics 0<CR>')

  if client.resolved_capabilities.document_formatting then
    cur_bmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  elseif client.resolved_capabilities.document_range_formatting then
    cur_bmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  end
end

require('lspfuzzy').setup {}

local lspconfig = require('lspconfig')
lspconfig.jedi_language_server.setup {
  on_attach = on_attach
}
lspconfig.efm.setup {
  on_attach = on_attach,
  filetypes = {'python', 'markdown', 'yaml'}
}
lspconfig.pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        useLibraryCodeForTypes = false
      }
    }
  }

}

--- }}} ---
