local ok, dap = pcall(require, "dap")

if not ok then
  return nil
end

local dap_go_ok, dap_go = pcall(require, "dap-go")

if dap_go_ok then
  dap_go.setup()
end

dap.adapters.go = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true,
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print("dlv exited with code", code)
    end
  end)
  assert(handle, "Error running dlv: " .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(function()
    callback { type = "server", host = "127.0.0.1", port = port }
  -- Timeout needed bumping because dlv is slow to start
  end, 250)
end

local map = require("mc4.shortcuts").map

if dap_go_ok then
  map("n", "<leader>dt", "<Cmd>lua require('dap-go').debug_test()<CR>")
end
map("n", "<leader>db", "<Cmd>lua require('dap').toggle_breakpoint()<CR>")
map("n", "<leader>dc", "<Cmd>lua require('dap').continue()<CR>")
map("n", "<leader>dr", "<Cmd>lua require('dap').repl.toggle()<CR>")
