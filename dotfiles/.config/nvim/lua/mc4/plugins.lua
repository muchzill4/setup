local fn = vim.fn
local cmd = vim.api.nvim_command

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
end
cmd 'packadd packer.nvim'

require('packer').startup({{
  {'wbthomason/packer.nvim', opt = true},

  {'neovim/nvim-lspconfig'},
  {'nvim-treesitter/nvim-treesitter'},
  {'Vimjas/vim-python-pep8-indent'},

  {'hrsh7th/nvim-compe'},
  {'hrsh7th/vim-vsnip', requires={'rafamadriz/friendly-snippets'}},

  {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  },
  {'nvim-telescope/telescope-fzy-native.nvim'},

  {'janko-m/vim-test'},
  {'tpope/vim-commentary'},
  {'tpope/vim-fugitive'},
  {'tpope/vim-obsession'},
  {'tpope/vim-rhubarb'},
  {'tpope/vim-surround'},
  {'tpope/vim-unimpaired'},
  {'tpope/vim-vinegar'},
  {'ryvnf/readline.vim'},
  {'Yggdroot/indentLine'},
}})