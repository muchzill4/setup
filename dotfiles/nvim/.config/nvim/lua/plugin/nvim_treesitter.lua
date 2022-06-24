local configs = prequire "nvim-treesitter.configs"

if not configs then
  return nil
end

configs.setup {
  ensure_installed = {
    "bash",
    "fish",
    "go",
    "gomod",
    "gowork",
    "javascript",
    "lua",
    "make",
    "markdown",
    "python",
    "typescript",
    "yaml",
  },
  highlight = { enable = true },
  indent = {
    enable = true,
    disable = { "python", "yaml" },
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
}
