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
    cmd = { "Gbrowse" },
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

  {
    event = { "VeryLazy" },
    "sindrets/diffview.nvim",
    opts = {
      use_icons = false,
      icons = {
        folder_closed = "▸",
        folder_open = "▾",
      },
      signs = {
        fold_closed = "▸",
        fold_open = "▾",
        done = "✓",
      },
    },
    config = function(_, opts)
      local dv = require "diffview"
      dv.setup(opts)

      local function DiffviewToggle()
        local lib = require "diffview.lib"
        local view = lib.get_current_view()
        if view then
          -- Current tabpage is a Diffview; close it
          vim.cmd ":DiffviewClose"
        else
          -- No open Diffview exists: open a new one
          vim.cmd ":DiffviewOpen"
        end
      end

      map("n", "<leader>G", DiffviewToggle)
    end,
  },
}
