return {
  "tpope/vim-eunuch", -- Helpers for UNIX (:Remove, :Move, etc.)
  "tpope/vim-unimpaired", -- Pairs of handy bracket mappings
  "tpope/vim-surround", -- Delete/change/add parentheses/quotes/XML-tags/much more with ease

  {
    "tpope/vim-projectionist",
    event = { "BufReadPre", "BufNewFile" }, -- projectionist needs to be loaded for cmd to be available?
    config = function()
      vim.g["projectionist_heuristics"] = {
        ["go.mod"] = {
          ["*.go"] = {
            type = "source",
            alternate = "{}_test.go",
          },
          ["*_test.go"] = {
            type = "test",
            alternate = "{}.go",
          },
        },
        ["Cargo.toml"] = {
          ["*.rs"] = {
            type = "source",
            alternate = "{}_tests.rs",
          },
          ["*_tests.rs"] = {
            type = "test",
            alternate = "{}.rs",
          },
        },
        ["package.json"] = {
          ["*.ts"] = {
            type = "source",
            alternate = "{}.test.ts",
          },
          ["*.test.ts"] = {
            type = "test",
            alternate = "{}.ts",
          },
          ["*.tsx"] = {
            type = "source",
            alternate = "{}.test.tsx",
          },
          ["*.test.tsx"] = {
            type = "test",
            alternate = "{}.tsx",
          },
        },
        ["requirements.txt|pyproject.toml|uv.lock"] = {
          ["*.py"] = {
            type = "source",
            alternate = "test_{}.py",
          },
          ["test_*.py"] = {
            type = "test",
            alternate = "{}.py",
          },
        },
        ["mix.exs"] = {
          ["lib/*.ex"] = {
            type = "source",
            alternate = "test/{}_test.exs",
          },
          ["test/*_test.exs"] = {
            type = "test",
            alternate = "lib/{}.ex",
          },
        },
      }
    end,
  },

  {
    "knubie/vim-kitty-navigator",
    build = { "cp ./*.py ~/.config/kitty/" },
    init = function() vim.g["kitty_navigator_enable_stack_layout"] = 1 end,
  },

  {
    "itspriddle/vim-marked",
    init = function()
      extend_palette {
        {
          name = "markdown preview",
          cmd = "MarkedOpen!",
          show = function() return vim.bo.filetype == "markdown" end,
        },
      }
    end,
  },

  {
    "stevearc/oil.nvim",
    lazy = false,
    keys = {
      { "-", "<Cmd>Oil<CR>" },
    },
    opts = {
      keymaps = {
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-h>"] = false,
        ["<C-l>"] = false,
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    config = true,
  },
}
