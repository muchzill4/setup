cmd, fn = vim.api.nvim_command, vim.fn

local M = {}

local function build_map_opts(opts)
  local defaults = {noremap = true}
  if opts then
    return vim.tbl_extend('force', defaults, opts) 
  end
  return defaults
end

function M.map(mode, lhs, rhs, opts)
  local options = build_map_opts(opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.bmap(bufnr, mode, lhs, rhs, opts)
  local options = build_map_opts(opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

-- https://github.com/tjdevries/astronauta.nvim
function M.source_plugins()
  for _, mod in ipairs(vim.api.nvim_get_runtime_file('lua/plugin/**/*.lua', true)) do
    local ok, msg = pcall(loadfile(mod))

    if not ok then
      print("Failed to load: ", mod)
      print("\t", msg)
    end
  end
end

return M
