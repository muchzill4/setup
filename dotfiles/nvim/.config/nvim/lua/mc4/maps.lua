-- leader
map("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- C-o to exit insert in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalExitInsertCustomMap", {}),
  pattern = "*",
  command = [[tnoremap <buffer> <C-o> <C-\><C-n>]],
})

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

-- :bdelete
map("n", "<Leader>q", "<Cmd>bdelete<CR>")
map("n", "<Leader>Q", "<Cmd>bdelete!<CR>")
