local function lsp_diagnostics()
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

local function obsession_status()
  local status = vim.fn.ObsessionStatus()
  if status == "[$]" then
    return "[$]"
  end
  return ""
end

local function branch()
  local b = vim.fn.FugitiveHead()
  if b ~= "" then
    return string.format("%%<%s", b)
  end
  return ""
end

local function filename()
  local data = vim.fn.expand "%:~:.:."
  if data == "" then
    return "[No Name]"
  end
  return data
end

function _G.statusline_active()
  return table.concat {
    filename(),
    " ",
    obsession_status(),
    "%h%m%r",
    "   %=",
    lsp_diagnostics(),
    "   ",
    branch(),
    "%10(%l:%c%)",
  }
end

vim.go.statusline = "%{%v:lua.statusline_active()%}"
