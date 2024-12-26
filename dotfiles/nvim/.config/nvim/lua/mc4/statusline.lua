local function lsp_diagnostics()
  local output = {}
  local diags = { "ERROR", "WARN", "INFO", "HINT" }
  local colors = { 1, 3, 4, 7 }
  for i = 1, #diags do
    local diag = diags[i]
    local color = colors[i]
    local count = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity[diag] }))
    if count > 0 then
      local symbol = string.sub(diag, 1, 1)
      table.insert(output, string.format("%%%d*%s:%d%%*", color, symbol, count))
    end
  end
  return table.concat(output, " ")
end

local function diff()
  local changes = vim.b["gitsigns_status"]
  if changes ~= nil then
    return changes
  end
  return ""
end

local function branch()
  local head = vim.b["gitsigns_head"]
  if head ~= nil then
    return "%<" .. head
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
    branch(),
    " ",
    diff(),
    "%10(%l:%c%)",
  }
end

_G.statusline = statusline_active

vim.go.statusline = "%{%v:lua.statusline()%}"
