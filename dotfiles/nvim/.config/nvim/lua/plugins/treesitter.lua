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
        "python",
        "yaml",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "gitcommit" },
      },
      indent = {
        enable = true,
        disable = { "yaml" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "v",
          node_incremental = "v",
          node_decremental = "V",
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
