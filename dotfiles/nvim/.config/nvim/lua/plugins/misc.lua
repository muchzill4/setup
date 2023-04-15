return {
  "tpope/vim-obsession",

  {
    "tpope/vim-surround",
    event = { "VeryLazy" },
  },

  {
    "tpope/vim-unimpaired",
    event = { "VeryLazy" },
  },

  {
    "tpope/vim-vinegar",
    keys = { "-" },
  },

  {
    "knubie/vim-kitty-navigator",
    event = { "VeryLazy" },
    build = { "cp ./*.py ~/.config/kitty/" },
    init = function()
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup(
          "KittyNavigatorNetrwMapOverride",
          {}
        ),
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
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  {
    "windwp/nvim-projectconfig",
    event = { "VeryLazy" },
    opts = {
      project_dir = "~/.local/share/projectconfig/",
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    init = function()
      extend_palette {
        {
          name = "markdown preview",
          cmd = "MarkdownPreview",
          show = function()
            return vim.bo.filetype == "markdown"
          end,
        },
      }
    end,
  },
}
