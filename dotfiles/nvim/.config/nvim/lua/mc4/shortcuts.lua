local function build_map_opts(opts)
  local defaults = { noremap = true }
  if opts then
    return vim.tbl_extend("force", defaults, opts)
  end
  return defaults
end

_G.map = function(mode, lhs, rhs, opts)
  local options = build_map_opts(opts)
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

_G.bmap = function(bufnr, mode, lhs, rhs, opts)
  local options = build_map_opts(opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

_G.prequire = function(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    return nil, err
  end
  return err
end
