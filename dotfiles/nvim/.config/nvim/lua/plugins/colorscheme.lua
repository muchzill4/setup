return {
  dir = "~/Dev/my/doubletrouble",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    vim.opt.termguicolors = true
    vim.cmd "colorscheme doubletrouble"
  end,
}
