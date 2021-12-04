local fn = vim.fn
local cmd = vim.api.nvim_command

local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end
cmd "packadd packer.nvim"

require("packer").startup {
  {
    { "wbthomason/packer.nvim", opt = true },

    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "Vimjas/vim-python-pep8-indent",

    {
      "hrsh7th/nvim-cmp",
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    {
      "dcampos/nvim-snippy",
      requires = {
        "dcampos/cmp-snippy",
        "honza/vim-snippets",
      },
    },

    {
      "nvim-telescope/telescope.nvim",
      requires = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-live-grep-raw.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      },
    },

    "mfussenegger/nvim-dap",
    "nvim-telescope/telescope-dap.nvim",
    "rcarriga/nvim-dap-ui",
    "janko-m/vim-test",

    { "~/Dev/my/doubletrouble", requires = { "rktjmp/lush.nvim" } },
    "knubie/vim-kitty-navigator",
    "lewis6991/impatient.nvim",
    "tpope/vim-commentary",
    "tpope/vim-fugitive",
    "tpope/vim-obsession",
    "tpope/vim-rhubarb",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    "tpope/vim-vinegar",
    "windwp/nvim-projectconfig",
  },
  config = {
    -- for impatient.vim
    compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
  },
}

pcall(require, "packer_compiled")
