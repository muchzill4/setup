local lspconfig = prequire "lspconfig"

if not lspconfig then
  return nil
end

vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
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

  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, diagnostic_float_opts)
    end,
  })
end

local function get_venv_path()
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV
  end

  local path = require("lspconfig.util").path

  if vim.fn.isdirectory(path.join(vim.fn.getcwd(), ".venv")) then
    return ".venv"
  end

  return ""
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp = prequire "cmp_nvim_lsp"
if cmp_nvim_lsp then
  capabilities = require("cmp_nvim_lsp").default_capabilities()
end

local servers = { "tsserver", "svelte", "cssls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
  }
end

lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "htmldjango" },
}

lspconfig.jedi_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd_env = { VIRTUAL_ENV = get_venv_path() },
}

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

local null_ls = prequire "null-ls"
local lsp_format = prequire "lsp-format"

if lsp_format then
  lsp_format.setup()
end

if null_ls then
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
      if lsp_format then
        lsp_format.on_attach(client)
      end
    end,
  }
end
