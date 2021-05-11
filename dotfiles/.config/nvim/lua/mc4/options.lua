local cmd = vim.api.nvim_command

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
vim.o.pumblend = 10
cmd [[hi PmenuSel blend=0]]
vim.o.scrolloff = 8
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
local statusline = table.concat({
  '%<%f %h%m%r',
  '%=',
  '%l:%c',
  '%2*',
  [[%{luaeval("require('mc4.statusline').diag_count('Error')")}]],
  '%3*',
  [[%{luaeval("require('mc4.statusline').diag_count('Warning')")}]],
  '%4*',
  [[%{luaeval("require('mc4.statusline').diag_count('Info')")}]],
  '%1*',
  [[%{luaeval("require('mc4.statusline').branch_name()")}]],
  '%*',
  '%{ObsessionStatus(" $ ", " S ")}',
})
vim.o.statusline = statusline
vim.o.termguicolors = true
vim.o.tags = vim.o.tags..',.git/tags'
vim.o.updatetime = 200
vim.o.wildmode = 'longest:full,full'
vim.wo.colorcolumn = '80'
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

cmd 'au! BufWritePost init.lua :luafile %'
cmd 'au! BufWritePost mc4.lua :luafile %'
cmd 'au! TermOpen * startinsert'
cmd 'au! TextYankPost * lua vim.highlight.on_yank {on_visual = false, timeout = 200}'
cmd 'au! VimResized * wincmd ='

-- Don't show numbers
vim.api.nvim_exec([[
  augroup TerminalNumbers
    autocmd!
    au TermOpen * setlocal nonumber norelativenumber
  augroup end
]], false)

-- Load local vim config
local local_config = os.getenv('LOCAL_VIM_CONFIG')
if local_config ~= nil then
  -- Is this horrible?
  cmd(':luafile '..local_config)
end
