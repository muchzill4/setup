local function lsp_diagnostics()
  local output = {}
  local diags = { "ERROR", "WARN", "INFO", "HINT" }
  for i = 1, #diags do
    local diag = diags[i]
    local count = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[diag] }))
    if count > 0 then
      local symbol = string.sub(diag, 1, 1)
      table.insert(output, string.format("%s:%d", symbol, count))
    end
  end
  return table.concat(output, " ")
end

local function vcs()
  local branch = vim.b["gitsigns_head"]
  local changes = vim.b["gitsigns_status"]
  if branch ~= nil and changes ~= nil then
    return "%<" .. branch .. " " .. changes
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

local function statusline_active()
  return table.concat {
    filename(),
    " ",
    "%h%m%r",
    "   %=",
    lsp_diagnostics(),
    "   ",
    " ",
    vcs(),
    "%10(%l:%c%)",
  }
end

_G.statusline = statusline_active

vim.go.statusline = "%{%v:lua.statusline()%}"
