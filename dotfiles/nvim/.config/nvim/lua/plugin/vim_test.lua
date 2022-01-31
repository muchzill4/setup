vim.g["test#strategy"] = "neovim"

if vim.fn.executable "richgo" == 1 then
  vim.g["test#go#runner"] = "richgo"
end

local map = require("mc4.shortcuts").map

map("n", "<leader>l", "<Cmd>TestLast<CR>")
map("n", "<leader>t", "<Cmd>TestNearest<CR>")
