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

vim.lsp.enable { "elixirls", "luals", "basedpyright", "ruff", "css", "html", "gopls", "tsls" }
