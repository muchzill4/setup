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

  -- TODO: wrap this in if capabilities
  vim.api.nvim_command [[autocmd! DiagnosticChanged * lua vim.diagnostic.setloclist({ open = false })]]

  if client.server_capabilities.documentHighlightProvider then
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
local cmp_nvim_lsp = prequire "cmp_nvim_lsp"
if cmp_nvim_lsp then
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
end

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
