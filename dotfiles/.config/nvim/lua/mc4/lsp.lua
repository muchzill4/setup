local lspconfig = require('lspconfig')
local bmap = require('mc4.shortcuts').bmap

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- virtual_text = false,
  }
)

local function on_attach(client, bufnr)
  local function cur_bmap(mode, lhs, rhs, opts)
    bmap(bufnr, mode, lhs, rhs, opts)
  end

  cur_bmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  cur_bmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  cur_bmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  cur_bmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  cur_bmap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  cur_bmap('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
  cur_bmap('n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

  if client.resolved_capabilities.document_formatting then
    cur_bmap('n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  end
end

lspconfig.jedi_language_server.setup {
  on_attach = on_attach
}

lspconfig.tsserver.setup {
  on_attach = on_attach
}

local efm_tools = {
  prettier = {
    formatCommand = 'prettier --stdin-filepath ${INPUT}',
    formatStdin = true
  },
  flake8 = {
    lintCommand = 'flake8 --stdin-display-name ${INPUT} -',
    lintStdin = true,
    lintFormats = {'%f:%l:%c: %m'},
  },
  mypy = {
    lintCommand = 'mypy-stdin ${INPUT} -',
    lintFormats = {
      '%f:%l:%c: %trror: %m',
      '%f:%l:%c: %tarning: %m',
      '%f:%l:%c: %tote: %m',
    },
    lintStdin = true
  },
  black = {
    formatCommand = 'black --quiet -',
    formatStdin = true,
  },
  isort = {
    formatCommand = 'isort --quiet -',
    formatStdin = true,
  }
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
}

lspconfig.efm.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern('.git'),
  init_options = {
    documentFormatting = true,
    codeAction = true
  },
  settings = {
    languages = efm_languages
  },
  filetypes = vim.tbl_keys(efm_languages)
}