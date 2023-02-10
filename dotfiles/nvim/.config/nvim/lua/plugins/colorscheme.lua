return {
  dir = "~/Dev/my/doubletrouble",
  priority = 1000,
  lazy = false,
  config = function()
    vim.cmd "colorscheme doubletrouble"
    vim.o.termguicolors = true
  end,
}
