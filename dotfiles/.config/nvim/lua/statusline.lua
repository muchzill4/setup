local M = {}


function M.diag_count(severity)
  local has_lsp_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  if has_lsp_clients then
    symbol = string.sub(severity, 1, 1)
    count = vim.lsp.diagnostic.get_count(0, severity)
    if count > 0 then
      return string.format(' %s:%d ', symbol, count)
    end
  end
  return ''
end

function M.branch_name()
  local branch = vim.fn.FugitiveHead()
  if string.len(branch) > 0 then
    return string.format(' %s ', branch)
  end
  return ''
end

function M.obsession()
  local status = vim.fn.ObsessionStatus('on', 'off')
  if status == 'on' then
    return ' * '
  end
  return ''
end


return M
