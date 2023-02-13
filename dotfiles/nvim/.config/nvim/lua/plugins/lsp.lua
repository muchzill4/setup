vim.diagnostic.config {
  virtual_text = false,
}

local diagnostic_float_opts = {
  focusable = false,
  close_events = {
    "BufLeave",
    "CursorMoved",
    "InsertEnter",
    "FocusLost",
  },
  source = "if_many",
  prefix = "",
  scope = "cursor",
}

local function on_attach(client, bufnr)
  local opts = { buffer = bufnr }
  map("n", "<c-]>", vim.lsp.buf.definition, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
  map("n", "<leader>r", vim.lsp.buf.rename, opts)
  map("n", "]d", function()
    vim.diagnostic.goto_next(diagnostic_float_opts)
  end)
  map("n", "[d", function()
    vim.diagnostic.goto_prev(diagnostic_float_opts)
  end, opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = {
        cssls = {},
        gopls = {
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              analyses = {
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
              },
            },
          },
        },
        html = {},
        pyright = {
          settings = {
            python = {
              venvPath = ".venv",
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        tsserver = {},
      },
    },
    config = function(_, opts)
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local lspconfig = require "lspconfig"
      for server, config in pairs(opts.servers) do
        local merged = vim.tbl_extend("error", {
          capabilities = capabilities,
          on_attach = on_attach,
        }, config)
        lspconfig[server].setup(merged)
      end
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "lukas-reineke/lsp-format.nvim",
        config = true,
      },
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
        },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          require("lsp-format").on_attach(client)
        end,
      }
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = true,
  },
}
