local configs = prequire "nvim-treesitter.configs"

if not configs then
  return nil
end

configs.setup {
  ensure_installed = {
    "bash",
    "comment",
    "fish",
    "go",
    "gomod",
    "gowork",
    "help",
    "javascript",
    "lua",
    "make",
    "markdown",
    "python",
    "yaml",
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "gitcommit" },
  },
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

local context = prequire "treesitter-context"

if context then
  context.setup {
    max_lines = 5,
    trim_scope = "inner",
    mode = "cursor",
    patterns = {
      go = {
        "struct",
      },
    },
  }
end

local spread = prequire "spread"

if spread then
  map("n", "<leader>$o", spread.out)
  map("n", "<leader>$c", spread.combine)
end
