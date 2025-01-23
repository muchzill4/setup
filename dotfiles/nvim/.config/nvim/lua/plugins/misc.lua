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
    "knubie/vim-kitty-navigator",
    build = { "cp ./*.py ~/.config/kitty/" },
    init = function()
      vim.g["kitty_navigator_enable_stack_layout"] = 1
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("KittyNavigatorNetrwMapOverride", {}),
        pattern = "netrw",
        -- <C-l> is used to NetrwRefresh, which I never use
        command = [[
          nunmap <buffer> <c-l>
          nmap <buffer> <c-l> <Cmd>KittyNavigateRight<CR>
        ]],
      })
    end,
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
