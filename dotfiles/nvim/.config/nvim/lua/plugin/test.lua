vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "bo 20"

if vim.fn.executable "richgo" == 1 then
  vim.g["test#go#runner"] = "richgo"
end

map("n", "<leader>l", "<Cmd>TestLast<CR>")
map("n", "<leader>T", "<Cmd>TestFile<CR>")
map("n", "<leader>t", "<Cmd>TestNearest<CR>")
