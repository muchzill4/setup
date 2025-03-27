return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        backdrop = 100,
        preview = {
          layout = "vertical",
        },
      },
      keymap = {
        builtin = {
          ["<C-/>"] = "toggle-help",
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
      },
      grep = {
        rg_glob = true,
        glob_flag = "--iglob",
        glob_separator = "%s%-%-",
        RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
      },
    },
    config = function(_, opts)
      local fzf_lua = require "fzf-lua"
      fzf_lua.setup(opts)
      fzf_lua.register_ui_select()

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("FzFLuaLsp", {}),
        callback = function(args)
          local mopts = { buffer = args.buf }
          map("n", "<leader>d", function() require("fzf-lua").diagnostics_document() end, mopts)
          map("n", "<leader>D", function() require("fzf-lua").diagnostics_workspace() end, mopts)
          map("n", "<leader>j", function() require("fzf-lua").lsp_document_symbols() end)
          map(
            "n",
            "<leader>J",
            function() require("fzf-lua").lsp_live_workspace_symbols() end,
            mopts
          )
          map("n", "grr", function() require("fzf-lua").lsp_references() end)
          map("n", "gri", function() require("fzf-lua").lsp_implementations() end)
        end,
      })
    end,
    cmd = "FzfLua",
    keys = {
      { "<Leader><space>", function() require("fzf-lua").buffers() end },
      { "<Leader>h", function() require("fzf-lua").help_tags() end },
      { "<Leader>f", function() require("fzf-lua").files() end },
      { "<Leader>F", function() require("fzf-lua").files { cwd = "%:p:h" } end },
      { "<leader>P", function() require("fzf-lua").builtin() end },
      { "<Leader>s", function() require("fzf-lua").live_grep() end },
      { "<Leader>S", function() require("fzf-lua").grep_cword() end },
    },
  },

  {
    "muchzill4/yacp.nvim",
    dependencies = { "ibhagwan/fzf-lua" }, -- ensure fzf takes over vim.ui.select for "native" provider
    opts = {
      palette = {
        {
          name = "setup / dotfiles",
          cmd = function() require("fzf-lua").files { cwd = "~/Dev/my/setup" } end,
        },
        { name = "unload buffers", cmd = "%bd|edit#|bd#" },
      },
      enable_focus = true,
    },
    keys = {
      {
        "<Leader>p",
        function() require("yacp").yacp() end,
        mode = { "v", "n" },
      },
      { "@p", function() require("yacp").replay() end },
    },
  },
}
