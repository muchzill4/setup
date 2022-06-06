local cmd = vim.api.nvim_command

cmd "colorscheme doubletrouble-lush"

vim.o.expandtab = true
local indent = 2
vim.o.shiftwidth = indent
vim.o.tabstop = indent
vim.o.clipboard = "unnamed"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.gdefault = true
vim.o.hidden = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.list = true
vim.o.listchars = [[tab:»\ ,nbsp:␣,trail:•,extends:›,precedes:‹]]
vim.o.mouse = "a"
vim.o.pumblend = 5
cmd [[hi PmenuSel blend=0]]
vim.o.scrolloff = 8
vim.o.showmode = true
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.tags = vim.o.tags .. ",.git/tags"
vim.o.updatetime = 200
vim.o.wildmode = "longest:full,full"
vim.wo.colorcolumn = "80"
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

-- Faster startup
vim.g.loaded_python2_provider = false
vim.g.python3_host_prog = "~/.venvs/neovim/bin/python"

cmd "au! TextYankPost * lua vim.highlight.on_yank {timeout = 200}"
cmd "au! VimResized * wincmd ="

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    cmd "setlocal nonumber norelativenumber"
    cmd "startinsert"
  end,
})

-- Trim dat whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "%s/s+$//e",
})

-- Load local vim config
local local_config = os.getenv "LOCAL_VIM_CONFIG"
if local_config ~= nil then
  -- Is this horrible?
  cmd(":luafile " .. local_config)
end
