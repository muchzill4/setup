local map = require("mc4.shortcuts").map

-- leader
map("n", "<space>", "<Nop>")
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
map("n", "<leader>w", "<cmd>w<cr>")

-- Why, why, why
map("n", "Y", "y$")

-- Keeping it center
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")

-- Jumplist mutations
map("n", "j", [[(v:count >= 5 ? "m'" . v:count : "") . "j"]], {expr = true})
map("n", "k", [[(v:count >= 5 ? "m'" . v:count : "") . "k"]], {expr = true})
