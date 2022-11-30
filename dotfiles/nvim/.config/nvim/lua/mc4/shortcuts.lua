_G.map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

_G.prequire = function(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    return nil, err
  end
  return err
end
