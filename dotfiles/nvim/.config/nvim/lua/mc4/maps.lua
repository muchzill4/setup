-- leader
map("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- <Esc> to exit insert in terminal
map("t", "<Esc>", "<C-\\><C-n>")

-- :w
map("n", "<Leader>w", "<Cmd>w<CR>")

-- Why, why, why
map("n", "Y", "y$")

-- Keeping it center
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "J", "mzJ`z")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")

-- Jumplist mutations
map("n", "j", [[(v:count >= 5 ? "m'" . v:count : "") . "j"]], { expr = true })
map("n", "k", [[(v:count >= 5 ? "m'" . v:count : "") . "k"]], { expr = true })

-- Disable search highlight
map("n", "<Esc>", "<Cmd>nohlsearch<CR>")

-- Exit annoying snippet mode
map({ "i", "s" }, "<Esc>", function()
  vim.snippet.stop()
  return "<Esc>"
end, { expr = true })
