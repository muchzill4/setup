local M = {}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "pi" })
end

local function terminal_payload(message, submit)
  -- Bracketed paste keeps multi-line prompts together in pi's terminal editor.
  local payload = "\027[200~" .. message .. "\027[201~"
  if submit then
    payload = payload .. "\r"
  end
  return payload
end

local function system_ok(cmd, input)
  local output = vim.fn.system(cmd, input)
  return vim.v.shell_error == 0, output
end

local function nvim_instance_id()
  if vim.v.servername and vim.v.servername ~= "" then
    return vim.fn.sha256(vim.v.servername):sub(1, 8)
  end
  return tostring(vim.fn.getpid())
end

local function instance()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/$", "")
  local project = vim.fn.fnamemodify(cwd, ":t")
  local instance_id = nvim_instance_id()
  return {
    instance_id = instance_id,
    title = "pi:" .. project .. ":" .. instance_id,
    cwd = cwd,
  }
end

local function kitty_cmd(args)
  local cmd = { "kitty", "@" }
  vim.list_extend(cmd, args)
  return cmd
end

local function walk_windows(callback)
  local ok, output = system_ok(kitty_cmd { "ls" })
  if not ok then
    return nil, output
  end

  local decoded = vim.json.decode(output)
  for _, os_window in ipairs(decoded or {}) do
    for _, tab in ipairs(os_window.tabs or {}) do
      for _, window in ipairs(tab.windows or {}) do
        local result = callback(window)
        if result ~= nil then
          return result
        end
      end
    end
  end
end

local function find_window(pi_instance)
  return walk_windows(function(window)
    local vars = window.user_vars or window.vars or {}
    if vars.pi_instance_id == pi_instance.instance_id then
      return window
    end
  end)
end

local function ensure_window(config, command, opts)
  opts = opts or {}
  local pi_instance = instance()
  local window = find_window(pi_instance)
  if window then
    return window.id, false, pi_instance
  end

  local launch_args = {
    "launch",
    "--type=" .. config.launch_type,
  }
  if not opts.focus then
    table.insert(launch_args, "--keep-focus")
  end
  vim.list_extend(launch_args, {
    "--title",
    pi_instance.title,
    "--var",
    "pi_instance_id=" .. pi_instance.instance_id,
    "--cwd",
    pi_instance.cwd,
  })
  vim.list_extend(launch_args, command)

  local ok, output = system_ok(kitty_cmd(launch_args))
  if not ok then
    notify("Could not open kitty pi window: " .. output, vim.log.levels.ERROR)
    return nil, false, pi_instance
  end

  return tonumber(vim.trim(output)), true, pi_instance
end

local function focus_window(id)
  return system_ok(kitty_cmd { "focus-window", "--match", "id:" .. id })
end

local function open(config, command, opts)
  opts = opts or {}
  local id, opened, pi_instance = ensure_window(config, command, opts)
  if not id then
    return false
  end

  if opts.focus then
    local focused, output = focus_window(id)
    if not focused then
      notify("Could not focus kitty pi window: " .. output, vim.log.levels.ERROR)
      return false
    end
  end

  notify(
    (opened and "Opened" or opts.focus and "Focused" or "Found")
      .. " pi window "
      .. pi_instance.title
  )
  return true
end

local function send(config, command, message, opts)
  opts = opts or {}
  -- When sending to a newly launched kitty window, keep Neovim focused until
  -- after send-text runs. Otherwise kitty can steal focus before the deferred
  -- paste, which is especially noticeable from visual-mode mappings.
  local launch_opts = vim.tbl_extend("force", opts, { focus = false })
  local id, opened = ensure_window(config, command, launch_opts)
  if not id then
    return
  end

  local function send_payload()
    local sent, output = system_ok(
      kitty_cmd { "send-text", "--match", "id:" .. id, "--stdin" },
      terminal_payload(message, opts.submit ~= false)
    )
    if not sent then
      notify("Could not send to kitty pi window: " .. output, vim.log.levels.ERROR)
      return
    end

    if opts.focus then
      local focused, focus_output = focus_window(id)
      if not focused then
        notify("Could not focus kitty pi window: " .. focus_output, vim.log.levels.ERROR)
      end
    end
  end

  if opened then
    vim.defer_fn(send_payload, 500)
  else
    send_payload()
  end
end

function M.configure(opts)
  opts = opts or {}
  local config = {
    command = opts.command,
    launch_type = opts.launch_type or "window",
  }
  if config.launch_type ~= "window" and config.launch_type ~= "tab" and config.launch_type ~= "os-window" then
    notify("Invalid kitty launch type: " .. tostring(opts.launch_type), vim.log.levels.ERROR)
    return
  end

  return {
    open = function(opts_)
      return open(config, config.command, opts_)
    end,
    send = function(message, opts_)
      return send(config, config.command, message, opts_)
    end,
  }
end

return M
