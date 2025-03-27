return {
  "saghen/blink.cmp",
  version = "v0.*",
  opts = {
    completion = {
      menu = { border = "none" },
      accept = { auto_brackets = { enabled = false } },
    },
  },
  config = function(_, opts)
    local blink = require "blink.cmp"
    blink.setup(opts)
    vim.lsp.config("*", {
      capabilities = blink.get_lsp_capabilities(),
    })
  end,
}
