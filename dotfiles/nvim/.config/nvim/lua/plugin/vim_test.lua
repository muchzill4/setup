vim.g["test#strategy"] = "neovim"

if vim.fn.executable "richgo" == 1 then
  vim.g["test#go#runner"] = "richgo"
end

local map = require("mc4.shortcuts").map

map("n", "<leader>tf", "<Cmd>TestFile<CR>")
map("n", "<leader>tl", "<Cmd>TestLast<CR>")
map("n", "<leader>ts", "<Cmd>TestSuite<CR>")
map("n", "<leader>tt", "<Cmd>TestNearest<CR>")
