local context = require "agent.context"

local adapters = {
  neovim = require "agent.adapters.neovim",
  kitty = require "agent.adapters.kitty",
}

local defaults = {
  command = { "pi" },
  adapter = {
    name = "neovim",
  },
}

local configured_adapter = nil

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "pi" })
end

local M = {}

function M.setup(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {}, defaults, opts)

  local adapter = adapters[opts.adapter.name]
  if not adapter then
    notify("Invalid adapter: " .. tostring(opts.name), vim.log.levels.ERROR)
    return
  end

  local adapter_opts = vim.tbl_deep_extend("force", {}, { command = opts.command }, opts.adapter)

  configured_adapter = adapter.configure(adapter_opts)
end

function M.send(message, opts) configured_adapter.send(message, opts or {}) end

function M.send_selection(opts)
  opts = opts or {}
  local extra = context.selection_context()
  if extra == "" then
    notify("No visual selection", vim.log.levels.WARN)
    return
  end

  if opts.prompt and opts.prompt ~= "" then
    M.send(
      context.with_prompt(opts.prompt, extra),
      vim.tbl_extend("force", opts, { submit = true })
    )
  else
    M.send(extra, vim.tbl_extend("force", opts, { submit = false }))
  end
end

function M.open(opts) configured_adapter.open(opts or {}) end

return M
