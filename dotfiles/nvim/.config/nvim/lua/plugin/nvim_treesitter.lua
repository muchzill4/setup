local ok, configs = pcall(require, "nvim-treesitter.configs")

if not ok then
  return nil
end

configs.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc" },
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "python", "yaml" },
  },
}
