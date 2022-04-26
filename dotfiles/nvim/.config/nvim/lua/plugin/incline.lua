local ok, incline = pcall(require, "incline")

if not ok then
  return nil
end

incline.setup {
  window = {
    placement = { horizontal = "right", vertical = "bottom" },
  },
}
