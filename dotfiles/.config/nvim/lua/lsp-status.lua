local M = {}

function M.diagnostics_info()
  local has_lsp_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  if has_lsp_clients then
    local symbols = {'E', 'W', 'I'}
    local stats = {
      vim.lsp.diagnostic.get_count(0, 'Error'),
      vim.lsp.diagnostic.get_count(0, 'Warning'),
      vim.lsp.diagnostic.get_count(0, 'Info'),
    }

    local infos = {}
    for i = 1, #symbols do
      if stats[i] > 0 then
        info = string.format('%s:%d', symbols[i], stats[i])
        table.insert(infos, info)
      end
    end

    local info = table.concat(infos, ' ')
    if info ~= '' then
      return string.format('[%s]', info)
    end
  end
  return ''
end

return M
