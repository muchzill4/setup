local configs = prequire "nvim-treesitter.configs"

if not configs then
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
