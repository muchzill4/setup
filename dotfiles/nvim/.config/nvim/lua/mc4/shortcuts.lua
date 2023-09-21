_G.map = vim.keymap.set

_G.prequire = function(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    return nil, err
  end
  return err
end

_G.extend_palette = function(entries)
  local palette = prequire "yacp.palette"
  if palette then
    palette.extend(entries)
  end
end
