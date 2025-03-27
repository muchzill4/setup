vim.diagnostic.config {
  float = {
    severity_sort = true,
  },
  jump = {
    float = true,
  },
}

local augroup_lsp_config = vim.api.nvim_create_augroup("UserLspConfig", {})
local augroup_highlight = vim.api.nvim_create_augroup("UserLspHighlight", {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup_lsp_config,
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "go", vim.lsp.buf.type_definition, opts)

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return
    end

    if client:supports_method "textDocument/documentHighlight" then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = augroup_highlight,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
        group = augroup_highlight,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup_lsp_config,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    if client:supports_method "textDocument/documentHighlight" then
      vim.api.nvim_clear_autocmds { buffer = args.buf, group = augroup_highlight }
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = {
        cssls = {},
        clangd = {
          cmd = {
            "clangd",
            "--clang-tidy",
          },
        },
        elixirls = {
          cmd = { os.getenv "HOME" .. "/Dev/vcs/elixir-ls/language_server.sh" },
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
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "standard",
              },
            },
          },
        },
        ruff = {},
        rust_analyzer = {},
        ts_ls = {},
      }
    end,
    config = function(_, opts)
      local lspconfig = require "lspconfig"
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },

  {
    "j-hui/fidget.nvim",
    config = true,
  },
}
