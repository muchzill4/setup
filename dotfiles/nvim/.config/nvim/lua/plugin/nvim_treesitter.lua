local ok, configs = pcall(require, "nvim-treesitter.configs")

if not ok then
  return nil
end

configs.setup {
  ensure_installed = {
    "bash",
    "fish",
    "go",
    "gomod",
    "gowork",
    "javascript",
    "lua",
    "make",
    "markdown",
    "python",
    "typescript",
    "yaml",
  },
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "python", "yaml" },
  },
}
