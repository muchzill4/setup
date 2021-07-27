local ok, configs = pcall(require, 'nvim-treesitter.configs')

if not ok then
  return nil
end

configs.setup {
  ensure_installed = "maintained",
  highlight = {
    enable = true
  },
  indent = {
    enable = true,
    disable = {"python", "yaml"}
  }
}
