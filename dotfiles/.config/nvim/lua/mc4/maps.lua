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
