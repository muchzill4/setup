return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    dependencies = {
      "tpope/vim-rhubarb",
    },
    keys = {
      { "<leader>g", "<Cmd>Git<CR>" },
    },
    config = function()
      extend_palette {
        { name = "git browse", cmd = ".GBrowse" },
        { name = "git blame", cmd = "Git blame" },
        { name = "git log", cmd = "Git log --oneline -100" },
        { name = "git buffer log", cmd = "Git log --oneline -100 %" },
        { name = "git diff", cmd = "Gdiffsplit!" },
        { name = "git push", cmd = "Git push" },
        { name = "git push --force", cmd = "Git push --force" },
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local gitsigns = require "gitsigns"
      gitsigns.setup {
        on_attach = function(bufnr)
          local opts = { buffer = bufnr, expr = true }

          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gitsigns.next_hunk()
            end)
            return "<Ignore>"
          end, opts)

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gitsigns.prev_hunk()
            end)
            return "<Ignore>"
          end, opts)
        end,
      }
    end,
  },
}