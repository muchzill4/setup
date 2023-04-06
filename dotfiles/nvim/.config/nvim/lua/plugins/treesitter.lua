return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash",
        "comment",
        "fish",
        "go",
        "gomod",
        "gowork",
        "help",
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
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },
}
