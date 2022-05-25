local ok, lspconfig = pcall(require, "lspconfig")

if not ok then
  return nil
end

local bmap = require("mc4.shortcuts").bmap

vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
}

local function on_attach(client, bufnr)
  local function cur_bmap(mode, lhs, rhs, opts)
    bmap(bufnr, mode, lhs, rhs, opts)
  end

  cur_bmap("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<CR>")
  cur_bmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  cur_bmap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  cur_bmap("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<CR>")
  cur_bmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  cur_bmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  cur_bmap(
    "n",
    "<leader>d",
    "<cmd>lua vim.diagnostic.setloclist({ open = true })<CR>"
  )

  vim.api.nvim_command [[autocmd! DiagnosticChanged * lua vim.diagnostic.setloclist({ open = false })]]

  if client.server_capabilities.document_formatting then
    vim.api.nvim_command [[autocmd! BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
  end
  if client.server_capabilities.document_highlight then
    vim.api.nvim_command [[autocmd! CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command [[autocmd! CursorHoldI  <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.api.nvim_command [[autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    vim.api.nvim_command [[autocmd! BufLeave <buffer> lua vim.lsp.buf.clear_references()]]
  end
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
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local servers = { "tsserver", "gopls", "svelte", "cssls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
  }
end

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

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

local efm_tools = {
  prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT}",
    formatStdin = true,
  },
  flake8 = {
    lintCommand = "flake8 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintFormats = { "%f:%l:%c: %m" },
  },
  mypy = {
    lintCommand = "mypy-stdin ${INPUT} -",
    lintFormats = {
      "%f:%l:%c: %trror: %m",
      "%f:%l:%c: %tarning: %m",
      "%f:%l:%c: %tote: %m",
    },
    lintStdin = true,
  },
  black = {
    formatCommand = "black --quiet -",
    formatStdin = true,
  },
  isort = {
    formatCommand = "isort --quiet -",
    formatStdin = true,
  },
  stylua = {
    formatCommand = "stylua -",
    formatStdin = true,
  },
}

local efm_languages = {
  python = {
    efm_tools.flake8,
    efm_tools.mypy,
    efm_tools.black,
    efm_tools.isort,
  },
  javascript = { efm_tools.prettier },
  markdown = { efm_tools.prettier },
  yaml = { efm_tools.prettier },
  lua = { efm_tools.stylua },
}

lspconfig.efm.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern ".git",
  init_options = {
    documentFormatting = true,
    codeAction = true,
  },
  settings = {
    languages = efm_languages,
  },
  filetypes = vim.tbl_keys(efm_languages),
}
