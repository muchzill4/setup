local function set_test_split_size()
  print "setting term position"
  local test_split_size = math.floor(vim.o.lines / 3)
  if test_split_size < 20 then
    test_split_size = math.floor(vim.o.lines / 2)
  end
  vim.g["test#neovim#term_position"] = "bo " .. test_split_size
end

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("SetTestSplitSize", {}),
  callback = set_test_split_size,
})

if vim.fn.executable "richgo" == 1 then
  vim.g["test#go#runner"] = "richgo"
end

set_test_split_size()
vim.g["test#strategy"] = "neovim"

map("n", "<leader>l", "<Cmd>TestLast<CR>")
map("n", "<leader>T", "<Cmd>TestFile<CR>")
map("n", "<leader>t", "<Cmd>TestNearest<CR>")
