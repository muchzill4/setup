return {
  "ThePrimeagen/refactoring.nvim",
  requires = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  keys = {},
  init = function()
    extend_palette {
      {
        name = "select refactor",
        cmd = "lua require('refactoring').select_refactor()",
      },
    }
  end,
}
