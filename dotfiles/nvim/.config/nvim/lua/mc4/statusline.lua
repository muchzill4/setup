local function lsp_diagnostics()
  local output = {}
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
  return table.concat(output, " ")
end

local function obsession_status()
  local status = vim.fn.ObsessionStatus()
  if status == "[$]" then
    return "[REC]"
  end
  return ""
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
    obsession_status(),
    "%h%m%r",
    "   %=",
    lsp_diagnostics(),
    "   ",
    " ",
    vcs(),
    "%10(%l:%c%)",
  }
end

local function statusline_inactive()
  return table.concat {
    filename(),
    " ",
    "%h%m%r",
  }
end

local function is_focussed()
  return tonumber(vim.g.actual_curwin) == vim.api.nvim_get_current_win()
end

function _G.statusline()
  if is_focussed() then
    return statusline_active()
  else
    return statusline_inactive()
  end
end

vim.go.statusline = "%{%v:lua.statusline()%}"
