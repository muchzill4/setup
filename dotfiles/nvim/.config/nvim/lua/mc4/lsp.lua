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

    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
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

vim.lsp.enable {
  "expert",
  "luals",
  "basedpyright",
  "ruff",
  "css",
  "html",
  "gopls",
  "golangci_lint",
  "tsls",
  "rust_analyzer",
}

local api, lsp = vim.api, vim.lsp
local get_clients = vim.lsp.get_clients

local function client_complete()
  --- @param c vim.lsp.Client
  --- @return string
  return vim.tbl_map(function(c) return c.name end, get_clients())
end

api.nvim_create_user_command("LspRestart", function(kwargs)
  local name = kwargs.fargs[1] --- @type string
  for _, client in ipairs(get_clients { name = name }) do
    local bufs = vim.deepcopy(client.attached_buffers)
    client:stop()
    vim.wait(30000, function() return lsp.get_client_by_id(client.id) == nil end)
    local client_id = lsp.start(client.config)
    if client_id then
      for buf in pairs(bufs) do
        lsp.buf_attach_client(buf, client_id)
      end
    end
  end
end, {
  nargs = "*",
  complete = client_complete,
})
