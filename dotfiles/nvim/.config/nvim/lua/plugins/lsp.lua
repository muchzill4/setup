local border = "rounded"

vim.lsp.handlers["textDocument/hover"] =
  vim.lsp.with(vim.lsp.handlers.hover, { border = border })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.diagnostic.config {
  virtual_text = false,
  float = {
    focusable = false,
    close_events = {
      "BufLeave",
      "CursorMoved",
      "InsertEnter",
      "FocusLost",
    },
    source = "if_many",
    prefix = "",
    header = "",
    scope = "cursor",
    border = border,
  },
}

map("n", "]d", vim.diagnostic.goto_next)
map("n", "[d", vim.diagnostic.goto_prev)

local augroup_format = vim.api.nvim_create_augroup("UserLspFormatting", {})

local function autocmd_format()
  vim.api.nvim_clear_autocmds { buffer = 0, group = augroup_format }
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
      vim.lsp.buf.format {}
    end,
  })
end

local augroup_highlight = vim.api.nvim_create_augroup("UserLspHighlight", {})

local function clear_autocmd_highlight(bufnr)
  vim.api.nvim_clear_autocmds { buffer = bufnr, group = augroup_highlight }
end

local function autocmd_highlight(bufnr)
  clear_autocmd_highlight(bufnr)
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = augroup_highlight,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
    group = augroup_highlight,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

local augroup_lsp_config = vim.api.nvim_create_augroup("UserLspConfig", {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup_lsp_config,
  callback = function(args)
    local opts = { buffer = args.buf }
    map("n", "<c-]>", vim.lsp.buf.definition, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
    map("n", "<leader>r", vim.lsp.buf.rename, opts)

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method "textDocument/documentHighlight" then
      autocmd_highlight(args.buf)
    end
    if client.name == "null-ls" then
      autocmd_format()
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup_lsp_config,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.supports_method "textDocument/documentHighlight" then
      clear_autocmd_highlight(args.buf)
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "folke/neodev.nvim",
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
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        tsserver = {},
      },
    },
    config = function(_, opts)
      require("neodev").setup {}
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      local lspconfig = require "lspconfig"
      for server, config in pairs(opts.servers) do
        local merged = vim.tbl_extend("error", {
          capabilities = capabilities,
        }, config)
        lspconfig[server].setup(merged)
      end
    end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
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
      }
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = true,
  },
}
