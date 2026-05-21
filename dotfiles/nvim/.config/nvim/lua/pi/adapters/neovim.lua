local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "pi" })
end

function M.configure(config)
  local command = config.command
  return {
    open = function(opts) return M.open(command, opts) end,
    send = function(message, opts) return M.send(command, message, opts) end,
  }
end

local pi_bufnr

local function terminal_payload(message, submit)
  -- Bracketed paste keeps multi-line prompts together in pi's terminal editor.
  local payload = "\027[200~" .. message .. "\027[201~"
  if submit then
    payload = payload .. "\r"
  end
  return payload
end

local function command_string(command)
  local parts = vim.tbl_map(vim.fn.shellescape, command)
  return table.concat(parts, " ")
end

local function valid_terminal(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.b[bufnr].terminal_job_id ~= nil
end

local function mark_pi_terminal(bufnr)
  pi_bufnr = bufnr
  vim.b[bufnr].pi_terminal = true
end

local function open_terminal(command)
  vim.cmd "botright split"
  vim.cmd.resize(15)
  vim.cmd.terminal(command_string(command))
  local bufnr = vim.api.nvim_get_current_buf()
  mark_pi_terminal(bufnr)
  return bufnr
end

local function terminal_name_looks_like_pi(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if not name:match "term://" then
    return false
  end

  local terminal_command = name:match ":([^:]*)$"
  if not terminal_command then
    return false
  end

  return vim.trim(terminal_command):match "%f[%w]pi$" ~= nil
end

local function find_pi_terminal()
  if valid_terminal(pi_bufnr) then
    return pi_bufnr
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if valid_terminal(bufnr) and vim.b[bufnr].pi_terminal then
      pi_bufnr = bufnr
      return bufnr
    end
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if valid_terminal(bufnr) and terminal_name_looks_like_pi(bufnr) then
      mark_pi_terminal(bufnr)
      return bufnr
    end
  end
end

local function ensure_terminal(command)
  local bufnr = find_pi_terminal()
  if bufnr then
    return bufnr, false
  end

  bufnr = open_terminal(command)
  if valid_terminal(bufnr) then
    return bufnr, true
  end
end

local function focus_terminal(bufnr)
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
      if vim.api.nvim_win_get_buf(winid) == bufnr then
        vim.api.nvim_set_current_tabpage(tabpage)
        vim.api.nvim_set_current_win(winid)
        return
      end
    end
  end

  vim.cmd "botright split"
  vim.api.nvim_win_set_buf(0, bufnr)
end

function M.open(command, opts)
  opts = opts or {}
  local previous_win = vim.api.nvim_get_current_win()
  local bufnr, opened = ensure_terminal(command)
  if not bufnr then
    notify("Could not open Neovim pi terminal", vim.log.levels.ERROR)
    return false
  end

  if opts.focus then
    focus_terminal(bufnr)
  elseif opened and vim.api.nvim_win_is_valid(previous_win) then
    vim.api.nvim_set_current_win(previous_win)
  end
  return true
end

function M.send(command, message, opts)
  opts = opts or {}
  local previous_win = vim.api.nvim_get_current_win()
  local bufnr, opened = ensure_terminal(command)
  if not bufnr then
    notify("Could not open Neovim pi terminal", vim.log.levels.ERROR)
    return
  end

  if not opts.focus and opened and vim.api.nvim_win_is_valid(previous_win) then
    vim.api.nvim_set_current_win(previous_win)
  end

  local function send_payload()
    if valid_terminal(bufnr) then
      vim.api.nvim_chan_send(
        vim.b[bufnr].terminal_job_id,
        terminal_payload(message, opts.submit ~= false)
      )
      if opts.focus then
        focus_terminal(bufnr)
      end
    end
  end

  if opened then
    vim.defer_fn(send_payload, 100)
  else
    send_payload()
  end
end

return M
