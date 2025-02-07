return {
  "tpope/vim-eunuch", -- Helpers for UNIX (:Remove, :Move, etc.)
  "tpope/vim-unimpaired", -- Pairs of handy bracket mappings

  {
    "tpope/vim-projectionist",
    event = { "BufReadPre", "BufNewFile" }, -- projectionist needs to be loaded for cmd to be available?
    keys = {
      { "<leader>a", "<Cmd>A<CR>" },
    },
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
      }
    end,
  },

  { "echasnovski/mini.ai", version = false, config = true }, -- extend and create `a`/`i` textobjects
  { "echasnovski/mini.surround", version = false, config = true }, -- fast and feature-rich surround actions

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
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
}
