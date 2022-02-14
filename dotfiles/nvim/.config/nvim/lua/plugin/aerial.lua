local ok, aerial = pcall(require, "aerial")

if not ok then
  return nil
end

aerial.setup {
  on_attach = function(bufnr)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      "<leader>a",
      "<cmd>AerialToggle!<CR>",
      {}
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "{", "<cmd>AerialPrev<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "}", "<cmd>AerialNext<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[[", "<cmd>AerialPrevUp<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]]", "<cmd>AerialNextUp<CR>", {})
  end,
  highlight_on_jump = false,
}
