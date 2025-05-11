return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash",
        "comment",
        "fish",
        "go",
        "gomod",
        "gowork",
        "javascript",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "vimdoc",
        "yaml",
      },
      auto_install = false,
      highlight = {
        enable = true,
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      multiwindow = true,
    },
  },
}
