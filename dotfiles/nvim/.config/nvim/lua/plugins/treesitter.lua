return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    init = function()
      require("nvim-treesitter").install {
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
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      multiwindow = true,
    },
  },
}
