vim.o.expandtab = true
local indent = 2

vim.o.shiftwidth = indent
vim.o.tabstop = indent
vim.o.breakindent = true
vim.o.clipboard = "unnamed"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.hidden = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.list = true
vim.o.listchars = [[tab:»\ ,nbsp:␣,trail:•,extends:›,precedes:‹]]
vim.o.mouse = "a"
vim.o.scrolloff = 4
vim.o.showmode = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tags = vim.o.tags .. ",.git/tags"
vim.o.updatetime = 200
vim.o.wildmode = "longest:full,full"
vim.o.undofile = true
vim.o.textwidth = 100
vim.o.colorcolumn = "+1"
vim.o.inccommand = "split"
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

-- Faster startup
vim.g.loaded_python2_provider = false
vim.g.python3_host_prog = "~/.venvs/neovim/bin/python"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Scale splits when resizing terminal
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ResizeSplitsOnWinResize", {}),
  pattern = "*",
  command = "wincmd =",
})

-- Trim dat whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("TrimTrailingWhitespace", {}),
  pattern = "*",
  command = "%s/s+$//e",
})

-- Load local vim config
local local_config = os.getenv "LOCAL_VIM_CONFIG"
if local_config ~= nil then
  -- Is this horrible?
  vim.cmd(":luafile " .. local_config)
end

-- Folds
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldmethod = "expr"
vim.wo.foldenable = false -- `zi` to toggle
