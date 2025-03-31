return {
  "saghen/blink.cmp",
  version = "v0.*",
  opts = {
    completion = {
      menu = {
        border = "none",
      },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
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
