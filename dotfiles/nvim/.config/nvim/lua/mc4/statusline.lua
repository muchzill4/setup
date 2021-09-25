local M = {}

local modes = {
  n = "Normal",
  no = "N·OpPd",
  v = "Visual",
  V = "V·Line",
  [""] = "V·Blck",
  s = "Select",
  S = "S·Line",
  [""] = "S·Blck",
  i = "Insert",
  ic = "ICompl",
  R = "Rplace",
  Rv = "VRplce",
  c = "Cmmand",
  cv = "Vim Ex",
  ce = "Ex (r)",
  r = "Prompt",
  rm = "More",
  ["r?"] = "Cnfirm",
  ["!"] = "Shell",
  t = "Term",
}

function M.mode()
  return modes[vim.api.nvim_get_mode().mode]
end

function M.lsp_diagnostics()
  local output = {}
  local has_lsp_clients = not vim.tbl_isempty(vim.lsp.buf_get_clients(0))
  if has_lsp_clients then
    local diags = { "Error", "Warning", "Hint", "Info" }
    for i = 1, #diags do
      local diag = diags[i]
      local count = vim.lsp.diagnostic.get_count(0, diag)
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
    return "[⊙]"
  end
  return ""
end

function M.branch()
  local branch = vim.fn.FugitiveHead()
  if branch ~= "" then
    return string.format(" %s", branch)
  end
  return ""
end

function M.file_icon()
  local ok, icon = pcall(function()
    local bufnr = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(bufnr)
    local ext = vim.fn.fnamemodify(name, ":e")
    return require("nvim-web-devicons").get_icon(name, ext, { default = true })
  end)
  return ok and icon or ""
end

local statusline = table.concat {
  [[ %{luaeval("require('mc4.statusline').file_icon()")} %<%f %h]],
  [[%{luaeval("require('mc4.statusline').obsession_status()")}]],
  "%m%r",
  "%=",
  [[ %20{luaeval("require('mc4.statusline').lsp_diagnostics()")} ]],
  "   ",
  [[%<%.30{luaeval("require('mc4.statusline').branch()")}]],
  "%10(%l:%c%)",
}
vim.o.statusline = statusline

return M
