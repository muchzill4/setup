extend_palette {
  {
    name = "github pull request",
    cmd = "!gh pr create --web --head (git branch --show-current)",
  },
}

return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gvdiffsplit", "Gwrite", "Gread" },
    keys = {
      { "<leader>g", "<Cmd>Git<CR>" },
    },
    init = function()
      extend_palette {
        { name = "git blame", cmd = "Git blame" },
        { name = "git log", cmd = "Git log --oneline -100" },
        { name = "git buffer log", cmd = "Git log --oneline -100 %" },
        { name = "git diff", cmd = "Gvdiffsplit!" },
        { name = "git push", cmd = "Git push" },
        { name = "git push --force", cmd = "Git push --force" },
      }
    end,
  },

  {
    "tpope/vim-rhubarb",
    event = "VeryLazy",
    dependencies = "tpope/vim-fugitive",
    init = function()
      extend_palette {
        { name = "git browse", cmd = ".GBrowse" },
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      preview_config = {
        border = "rounded",
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { buffer = bufnr, expr = true }

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, opts)

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, opts)
      end,
    },
  },
}
