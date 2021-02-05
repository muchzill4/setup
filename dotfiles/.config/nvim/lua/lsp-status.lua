local M = {}

function M.diagnostics_info()
  local has_lsp_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  if has_lsp_clients then
    local e = vim.lsp.diagnostic.get_count(0, 'Error')
    local w = vim.lsp.diagnostic.get_count(0, 'Warning')
    local i = vim.lsp.diagnostic.get_count(0, 'Info')
    return string.format('[E:%d|W:%d|I:%d]', e, w, i)
  else
    return ''
  end
end

return M
