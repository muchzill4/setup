vim.g["test#strategy"] = "neovim"

if vim.fn.executable "richgo" == 1 then
  vim.g["test#go#runner"] = "richgo"
end

map("n", "<leader>l", "<Cmd>TestLast<CR>")
map("n", "<leader>T", "<Cmd>TestFile<CR>")
map("n", "<leader>t", "<Cmd>TestNearest<CR>")