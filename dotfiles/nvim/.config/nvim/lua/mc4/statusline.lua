local M = {}

function M.lsp_diagnostics()
  local output = {}
  local has_lsp_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  if has_lsp_clients then
    local diags = { "ERROR", "WARN", "INFO", "HINT" }
    for i = 1, #diags do
      local diag = diags[i]
      local count = vim.tbl_count(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity[diag] })
      )
      if count > 0 then
        local symbol = string.sub(diag, 1, 1)
        table.insert(output, string.format("%s:%d", symbol, count))
      end
    end
  end
  return table.concat(output, " ")
end

function M.obsession_status()
  local status = vim.fn.ObsessionStatus()
  if status == "[$]" then
    return "[$]"
  end
  return ""
end

function M.branch()
  local branch = vim.fn.FugitiveHead()
  if branch ~= "" then
    return string.format("%s", branch)
  end
  return ""
end

function M.filename()
  local data = vim.fn.expand "%:~:."
  if data == "" then
    return "[No Name]"
  end
  return data
end

local statusline = table.concat {
  [[%<%{luaeval("require('mc4.statusline').filename()")} ]],
  [[%{luaeval("require('mc4.statusline').obsession_status()")}]],
  "%h%m%r",
  "%=",
  [[ %20{luaeval("require('mc4.statusline').lsp_diagnostics()")} ]],
  "   ",
  [[%<%.40{luaeval("require('mc4.statusline').branch()")}]],
  "%10(%l:%c%)",
}
vim.o.statusline = statusline

return M
