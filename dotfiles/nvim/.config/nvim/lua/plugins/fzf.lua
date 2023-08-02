return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      global_git_icons = false,
      global_file_icons = false,
      winopts = {
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
      },
    },
    config = function(_, opts)
      local fzf_lua = require "fzf-lua"
      fzf_lua.setup(opts)
      fzf_lua.register_ui_select()
    end,
    cmd = "FzfLua",
    keys = {
      { "<Leader><space>", "<Cmd>lua require('fzf-lua').buffers()<CR>" },
      {
        "<leader>c",
        "<Cmd>lua require('fzf-lua').lsp_code_actions()<CR>",
        mode = { "v", "n" },
      },
      { "<leader>d", "<Cmd>lua require('fzf-lua').diagnostics_document()<CR>" },
      {
        "<leader>D",
        "<Cmd>lua require('fzf-lua').diagnostics_workspace()<CR>",
      },
      { "<Leader>h", "<Cmd>lua require('fzf-lua').help_tags()<CR>" },
      { "<leader>j", "<Cmd>lua require('fzf-lua').lsp_document_symbols()<CR>" },
      {
        "<leader>J",
        "<Cmd>lua require('fzf-lua').lsp_live_workspace_symbols()<CR>",
      },
      { "<Leader>f", "<Cmd>lua require('fzf-lua').files()<CR>" },
      {
        "<Leader>F",
        "<Cmd>lua require('fzf-lua').files({cwd = '%:p:h' })<CR>",
      },
      {
        "<leader>P",
        "<Cmd>lua require('fzf-lua').builtin()<CR>",
      },
      {
        "<Leader>R",
        "<Cmd>lua require('fzf-lua').lsp_references()<CR>",
      },
      {
        "<Leader>s",
        "<Cmd>lua require('fzf-lua').live_grep()<CR>",
      },
      { "<Leader>S", "<Cmd>lua require('fzf-lua').grep_cword()<CR>" },
    },
  },

  {
    "muchzill4/yacp.nvim",
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
        "<Cmd>lua require('yacp').yacp()<CR>",
        mode = { "v", "n" },
      },
      { "@p", "<Cmd>lua require('yacp').replay()<CR>" },
    },
  },
}
