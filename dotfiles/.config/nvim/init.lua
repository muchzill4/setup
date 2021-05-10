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

  {'hrsh7th/nvim-compe'},
  {'hrsh7th/vim-vsnip', requires={'rafamadriz/friendly-snippets'}},

  {'junegunn/fzf'},
  {'junegunn/fzf.vim'},
  {'bronson/vim-visual-star-search'},

  {'janko-m/vim-test'},
  {'tpope/vim-commentary'},
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

vim.g.python3_host_prog = os.getenv('HOME')..'/.venvs/neovim3/bin/python'
vim.o.expandtab = true
local indent = 2
vim.o.shiftwidth = indent
vim.o.tabstop = indent
vim.o.clipboard = 'unnamed'
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.list = true
vim.o.listchars = [[tab:»\ ,nbsp:␣,trail:•,extends:›,precedes:‹]]
vim.o.mouse = 'a'
vim.wo.number = true
vim.o.scrolloff = 4
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
local statusline = table.concat({
  '%<%f %h%m%r',
  '%=',
  '%l:%c',
  '%2*',
  [[%{luaeval("require('mc4/statusline').diag_count('Error')")}]],
  '%3*',
  [[%{luaeval("require('mc4/statusline').diag_count('Warning')")}]],
  '%4*',
  [[%{luaeval("require('mc4/statusline').diag_count('Info')")}]],
  '%1*',
  [[%{luaeval("require('mc4/statusline').branch_name()")}]],
  '%*',
  '%{ObsessionStatus(" $ ", " S ")}',
})
vim.o.statusline = statusline
vim.o.termguicolors = true
vim.o.tags = vim.o.tags..',.git/tags'
vim.o.updatetime = 200
vim.o.wildmode = 'longest:full,full'
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.o.pumblend = 10
cmd [[hi PmenuSel blend=0]]
-- }}} --

-- MAPS {{{ --
map('n', '<space>', '<Nop>')
vim.g.mapleader = ' '
-- }}} --

-- PLUGIN SETUP {{{ --
-- nvim-compe
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
  };
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = fn.col('.') - 1
  if col == 0 or fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if fn.call("vsnip#jumpable", {1}) == 1 then
    return t "<Plug>(vsnip-jump-next)"
  elseif fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  elseif fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

map('i', '<CR>', [[compe#confirm('<CR>')]], {expr = true, noremap = false})
map('i', '<Tab>', 'v:lua.tab_complete()', {expr = true, noremap = false})
map('s', '<Tab>', 'v:lua.tab_complete()', {expr = true, noremap = false})
map('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true, noremap = false})
map('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true, noremap = false})

-- fzf
map('n', '<leader>f', ':Files<CR>')
map('n', '<leader>b', ':Buffers<CR>')
map('n', '<leader>t', ':Tags<CR>')
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
cmd 'au! BufWritePost mc4.lua :luafile %'
cmd 'au! TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}'
cmd 'au! VimResized * wincmd ='
cmd 'command! W w'

-- C-o to exit insert in terminal
-- Don't show numbers
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    au TermOpen * startinsert
    au TermOpen * tnoremap <buffer> <C-o> <C-\><C-n>
    au TermOpen * setlocal nonumber norelativenumber
  augroup end
]], false)

-- Load local vim config
local local_config = os.getenv('LOCAL_VIM_CONFIG')
if local_config ~= nil then
  -- Is this horrible?
  cmd(':luafile '..local_config)
end
-- }}} --

-- LSP {{{ --
require('lspfuzzy').setup {}

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
  end
end

local lspconfig = require('lspconfig')

lspconfig.jedi_language_server.setup {
  on_attach = on_attach,
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
}

local efm_tools = {
  prettier = {
    formatCommand = 'prettier --stdin-filepath ${INPUT}',
    formatStdin = true
  },
  flake8 = {
    lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'},
  },
  mypy = {
    lintCommand = 'mypy-stdin ${INPUT} -',
    lintFormats = {
      '%f:%l:%c: %trror: %m',
      '%f:%l:%c: %tarning: %m',
      '%f:%l:%c: %tote: %m',
    },
    lintStdin = true
  },
  black = {
    formatCommand = 'black --quiet -',
    formatStdin = true,
  },
  isort = {
    formatCommand = 'isort --quiet -',
    formatStdin = true,
  }
}

local efm_languages = {
  python = {
    efm_tools.flake8,
    efm_tools.mypy,
    efm_tools.black,
    efm_tools.isort,
  },
  javascript = { efm_tools.prettier },
  markdown = { efm_tools.prettier },
  yaml = { efm_tools.prettier },
}

lspconfig.efm.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('.git'),
  init_options = {
    documentFormatting = true,
    codeAction = true
  },
  settings = {
    languages = efm_languages
  },
  filetypes = vim.tbl_keys(efm_languages)
}
-- }}} --
