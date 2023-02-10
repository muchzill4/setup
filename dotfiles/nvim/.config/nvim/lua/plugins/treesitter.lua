return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local configs = require "nvim-treesitter.configs"
      configs.setup {
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
        textobjects = {
          select = {
            enable = true,

            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    opts = {
      max_lines = 5,
      trim_scope = "inner",
      mode = "cursor",
      patterns = {
        go = { "struct" },
      },
    },
  },

  {
    "aarondiel/spread.nvim",
    keys = {
      { "<leader>$o", "<Cmd>lua require('spread').out()<CR>" },
      { "<leader>$c", "<Cmd>lua require('spread').combine()<CR>" },
    },
  },
}
