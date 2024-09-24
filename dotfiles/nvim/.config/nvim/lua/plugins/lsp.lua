local border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })

vim.lsp.handlers["textDocument/signatureHelp"] =
  vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.diagnostic.config {
  virtual_text = false,
  float = {
    source = "if_many",
    border = border,
  },
}

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
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "go", vim.lsp.buf.type_definition, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "<leader>j", vim.lsp.buf.document_symbol, opts)
    map("n", "<leader>J", vim.lsp.buf.workspace_symbol, opts)

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.documentHighlightProvider then
      autocmd_highlight(args.buf)
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
    opts = function(_, opts)
      opts.servers = {
        cssls = {},
        clangd = {
          cmd = {
            "clangd",
            "--clang-tidy",
          },
        },
        gopls = {
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              semanticTokens = true,
              usePlaceholders = true,
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
            pyright = {
              disableOrganizeImports = true, -- Using Ruff
            },
            python = {
              venvPath = ".venv",
            },
          },
        },
        ruff = {},
        rust_analyzer = {},
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
            },
          },
        },
        ts_ls = {},
      }
    end,
    config = function(_, opts)
      require("neodev").setup {}
      local capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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
    "j-hui/fidget.nvim",
    config = true,
  },
}
