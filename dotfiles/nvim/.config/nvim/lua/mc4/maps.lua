local map = require("mc4.shortcuts").map

-- leader
map("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- C-o to exit insert in terminal
-- Don"t show numbers
vim.api.nvim_exec([[
  augroup TerminalInsert
    autocmd!
    au TermOpen * tnoremap <buffer> <C-o> <C-\><C-n>
  augroup end
]], false)

-- :W
vim.cmd "command! W w"
map("n", "<Leader>w", "<Cmd>w<CR>")

-- Why, why, why
map("n", "Y", "y$")

-- Keeping it center
map("n", "J", "mzJ`z")

-- Jumplist mutations
map("n", "j", [[(v:count >= 5 ? "m'" . v:count : "") . "j"]], {expr = true})
map("n", "k", [[(v:count >= 5 ? "m'" . v:count : "") . "k"]], {expr = true})

-- Mkdir
map("n", "<Leader>md", "<Cmd>!mkdir -p %:p:h<CR>")

-- copen, lopen
map("n", "<Leader>co", "<Cmd>copen<CR>")
map("n", "<Leader>lo", "<Cmd>lopen<CR>")
