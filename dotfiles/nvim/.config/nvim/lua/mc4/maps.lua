-- leader
map("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- C-o to exit insert in terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("TerminalExitInsertCustomMap", {}),
  pattern = "*",
  command = [[tnoremap <buffer> <C-o> <C-\><C-n>]],
})

-- :W
vim.cmd "command! W w"
map("n", "<Leader>w", "<Cmd>w<CR>")

-- Why, why, why
map("n", "Y", "y$")

-- Keeping it center
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "J", "mzJ`z")

-- Jumplist mutations
map("n", "j", [[(v:count >= 5 ? "m'" . v:count : "") . "j"]], { expr = true })
map("n", "k", [[(v:count >= 5 ? "m'" . v:count : "") . "k"]], { expr = true })

-- :bdelete
map("n", "<Leader>q", "<Cmd>bdelete<CR>")

-- :wq!
map("n", "<Leader>Q", "<Cmd>bdelete!<CR>")
