local M = {}

function M.diag_count(severity)
  local has_lsp_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  if has_lsp_clients then
    local symbol = string.sub(severity, 1, 1)
    local count = vim.lsp.diagnostic.get_count(0, severity)
    if count > 0 then
      return string.format(" %s:%d ", symbol, count)
    end
  end
  return ""
end

function M.branch_name()
  local branch = vim.fn.FugitiveHead()
  if string.len(branch) > 0 then
    return string.format(" %s ", branch)
  end
  return ""
end

function M.obsession_status()
  local status = vim.fn.ObsessionStatus()
  if status == "[$]" then
    return " ⊙ "
  end
  return ""
end

local statusline = table.concat({
  "%<%f %h%m%r",
  "%=",
  "%2*",
  [[%{luaeval("require('mc4.statusline').diag_count('Error')")}]],
  "%3*",
  [[%{luaeval("require('mc4.statusline').diag_count('Warning')")}]],
  "%4*",
  [[%{luaeval("require('mc4.statusline').diag_count('Info')")}]],
  "%5*",
  [[%{luaeval("require('mc4.statusline').diag_count('Hint')")}]],
  "%1*",
  [[%{luaeval("require('mc4.statusline').branch_name()")}]],
  "%2*",
  [[%{luaeval("require('mc4.statusline').obsession_status()")}]],
  "%*",
  "%-7.(%l:%c%)",
})
vim.o.statusline = statusline

return M
