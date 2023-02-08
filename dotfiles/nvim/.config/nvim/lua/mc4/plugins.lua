local install_path = vim.fn.stdpath "data"
  .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd(
    "!git clone https://github.com/wbthomason/packer.nvim " .. install_path
  )
end
vim.cmd "packadd packer.nvim"

require("packer").startup {
  {
    { "wbthomason/packer.nvim", opt = true },

    {
      "neovim/nvim-lspconfig",
      requires = {
        "j-hui/fidget.nvim",
        {
          "jose-elias-alvarez/null-ls.nvim",
          requires = {
            "nvim-lua/plenary.nvim",
          },
        },
        "lukas-reineke/lsp-format.nvim",
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
        "aarondiel/spread.nvim",
      },
    },
    "Vimjas/vim-python-pep8-indent",

    {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",

        "dcampos/nvim-snippy",
        "dcampos/cmp-snippy",
      },
    },

    {
      "mfussenegger/nvim-dap",
      requires = {
        "leoluz/nvim-dap-go",
        "rcarriga/nvim-dap-ui",
      },
    },

    {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",

        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "~/Dev/my/telescope-yacp.nvim",
      },
    },

    "vim-test/vim-test",

    { "~/Dev/my/doubletrouble", requires = { "rktjmp/lush.nvim" } },
    "knubie/vim-kitty-navigator",
    "lewis6991/gitsigns.nvim",
    "lewis6991/impatient.nvim",
    "numToStr/Comment.nvim",
    "tpope/vim-fugitive",
    "tpope/vim-obsession",
    "tpope/vim-rhubarb",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    "windwp/nvim-projectconfig",
    {
      "iamcco/markdown-preview.nvim",
      run = function()
        vim.fn["mkdp#util#install"]()
      end,
    },
  },
}

local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "source <afile> | PackerSync",
  group = packer_group,
  pattern = "**/mc4/plugins.lua",
})
