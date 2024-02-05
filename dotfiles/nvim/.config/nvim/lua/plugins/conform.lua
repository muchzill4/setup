return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      markdown = { "prettierd" },
      json = { "prettierd" },
      yaml = { "prettierd" },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
  },
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
}
