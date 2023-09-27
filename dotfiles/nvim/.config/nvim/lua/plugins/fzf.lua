return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      global_git_icons = false,
      global_file_icons = false,
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
          map(
            { "n", "v" },
            "<leader>c",
            function() require("fzf-lua").lsp_code_actions() end,
            mopts
          )
          map("n", "<leader>d", function() require("fzf-lua").diagnostics_document() end, mopts)
          map("n", "<leader>D", function() require("fzf-lua").diagnostics_workspace() end, mopts)
          map("n", "<leader>j", function() require("fzf-lua").lsp_document_symbols() end, mopts)
          map(
            "n",
            "<leader>J",
            function() require("fzf-lua").lsp_live_workspace_symbols() end,
            mopts
          )
          map("n", "<Leader>R", function() require("fzf-lua").lsp_references() end, mopts)
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
    dependencies = { "ibhagwan/fzf-lua" },
    opts = {
      provider = "fzf",
      palette = {
        {
          name = "setup / dotfiles",
          cmd = "lua require('fzf-lua').files({cwd='~/Dev/my/setup'})",
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
