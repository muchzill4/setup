local ok, lspconfig = pcall(require, "lspconfig")

if not ok then return nil end

local bmap = require("mc4.shortcuts").bmap

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
  }
)

local function on_attach(client, bufnr)
  local function cur_bmap(mode, lhs, rhs, opts)
    bmap(bufnr, mode, lhs, rhs, opts)
  end

  cur_bmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
  cur_bmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
  cur_bmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  cur_bmap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
  cur_bmap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")

  if client.resolved_capabilities.document_formatting then
    cur_bmap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
  end

  vim.api.nvim_command [[autocmd! CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })]]

  require("aerial").on_attach(client)
  cur_bmap("n", "<leader>a", "<cmd>AerialToggle!<CR>")
  cur_bmap("n", "{", "<cmd>AerialPrev<CR>")
  cur_bmap("n", "}", "<cmd>AerialNext<CR>")
  cur_bmap("n", "[[", "<cmd>AerialPrevUp<CR>")
  cur_bmap("n", "]]", "<cmd>AerialNextUp<CR>")
end

lspconfig.jedi_language_server.setup {
  on_attach = on_attach
}

lspconfig.tsserver.setup {
  on_attach = on_attach
}

lspconfig.solargraph.setup {
  on_attach = on_attach,
  settings = {
    solargraph = {
      diagnostics = false
    }
  }
}

lspconfig.svelte.setup {
  on_attach = on_attach
}

local css_capabilities = vim.lsp.protocol.make_client_capabilities()
css_capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup {
  capabilities = capabilities,
  on_attach = on_attach
}


local html_capabilities = vim.lsp.protocol.make_client_capabilities()
html_capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.html.setup {
  capabilities = html_capabilities,
  on_attach = on_attach,
  filetypes = { 'html', 'htmldjango' },
}

local sumneko_root_path = vim.fn.expand("$HOME/Dev/vcs/lua-language-server")
local sumneko_binary = sumneko_root_path .. "/bin/macOS/lua-language-server"

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you"re using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";")
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim"}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false
      }
    }
  }
}

local efm_tools = {
  prettier = {
    formatCommand = "prettier --stdin-filepath ${INPUT}",
    formatStdin = true
  },
  flake8 = {
    lintCommand = "flake8 --stdin-display-name ${INPUT} -",
    lintStdin = true,
    lintFormats = {"%f:%l:%c: %m"}
  },
  mypy = {
    lintCommand = "mypy-stdin ${INPUT} -",
    lintFormats = {
      "%f:%l:%c: %trror: %m",
      "%f:%l:%c: %tarning: %m",
      "%f:%l:%c: %tote: %m"
    },
    lintStdin = true
  },
  black = {
    formatCommand = "black --quiet -",
    formatStdin = true,
  },
  isort = {
    formatCommand = "isort --quiet -",
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
  root_dir = lspconfig.util.root_pattern(".git"),
  init_options = {
    documentFormatting = true,
    codeAction = true
  },
  settings = {
    languages = efm_languages
  },
  filetypes = vim.tbl_keys(efm_languages)
}
