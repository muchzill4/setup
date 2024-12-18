return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",

    "dcampos/nvim-snippy",
    "dcampos/cmp-snippy",
  },
  config = function()
    local cmp = require "cmp"
    local snippy = require "snippy"

    cmp.setup {
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args) snippy.expand_snippet(args.body) end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "snippy" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
      mapping = cmp.mapping.preset.insert {
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        },
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<C-l>"] = cmp.mapping(function()
          if snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if snippy.can_jump(-1) then
            snippy.previous()
          end
        end, { "i", "s" }),
      },
      window = {
        documentation = {
          border = "rounded",
          -- This makes no sense to me...
          winhighlight = "FloatBorder:FloatBorder",
        },
      },
    }
  end,
}
