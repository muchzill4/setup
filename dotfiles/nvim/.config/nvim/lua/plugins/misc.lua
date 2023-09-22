return {
  "tpope/vim-sleuth", -- Heuristically set buffer options
  "tpope/vim-eunuch", -- Helpers for UNIX (:Remove, :Move, etc.)
  "tpope/vim-unimpaired", -- Helpers for UNIX (:Remove, :Move, etc.)
  "tpope/vim-surround", -- Pairs of handy bracket mappings

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
      }
    end,
  },

  {
    "knubie/vim-kitty-navigator",
    build = { "cp ./*.py ~/.config/kitty/" },
    init = function()
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
    "numToStr/Comment.nvim",
    config = true,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
    ft = "markdown",
    init = function()
      extend_palette {
        {
          name = "markdown preview",
          cmd = "MarkdownPreview",
          show = function() return vim.bo.filetype == "markdown" end,
        },
      }
    end,
  },
}
