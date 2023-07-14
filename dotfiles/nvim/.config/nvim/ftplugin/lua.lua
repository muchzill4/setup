local augroup_format = vim.api.nvim_create_augroup("StyluaAutoformat", {})

vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    require("mc4.format.stylua").format(0)
  end,
})
