local border = "rounded"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })

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
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gT", vim.lsp.buf.type_definition, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
    map("n", "<leader>r", vim.lsp.buf.rename, opts)

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client.server_capabilities.documentHighlightProvider then
      autocmd_highlight(args.buf)
    end

    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_buf_set_option(args.buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
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
    opts = function(_, opts)
      opts.servers = {
        cssls = {},
        gopls = {
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
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
    tag = "legacy",
    event = "LspAttach",
    config = true,
  },
}
