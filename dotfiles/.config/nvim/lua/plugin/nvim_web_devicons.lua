local ok, devicons = pcall(require, 'nvim-web-devicons')

if not ok then return nil end

devicons.setup {
  default = true
}
