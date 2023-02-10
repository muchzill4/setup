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
    "knubie/vim-kitty-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
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
