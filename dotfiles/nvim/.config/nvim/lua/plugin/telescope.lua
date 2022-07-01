local telescope = prequire "telescope"

if not telescope then
  return nil
end

vim.api.nvim_command [[ hi link TelescopeMatching Function ]]
vim.api.nvim_command [[ hi link TelescopePromptCounter LineNr ]]

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    layout_strategy = "flex",
    winblend = 5,
    dynamic_preview_title = true,
    layout_config = {
      prompt_position = "top",
      flex = {
        flip_columns = 110,
      },
      vertical = {
        mirror = true,
      },
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<c-/>"] = actions.which_key,
      },
    },
  },
  pickers = {
    buffers = {
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer,
        },
        n = {
          ["<c-d>"] = actions.delete_buffer,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    file_browser = {
      grouped = true,
      sorting_strategy = "ascending",
      path = "%:p:h",
      dir_icon = "d",
      dir_icon_hl = "Directory",
    },
    yacp = {
      palette = {
        require("yacp.focus").palette_entry,
        {
          name = "lsp document symbols",
          cmd = "Telescope lsp_document_symbols",
        },
        {
          name = "lsp workspace symbols",
          cmd = "Telescope lsp_dynamic_workspace_symbols",
        },
        { name = "lsp diagnostics", cmd = "Telescope diagnostics" },
        { name = "test suite", cmd = "TestSuite" },
        { name = "git browse", cmd = ".GBrowse" },
        { name = "git blame", cmd = "Git blame" },
        { name = "git log", cmd = "Git log --oneline" },
        { name = "git buffer log", cmd = "Git log --oneline %" },
        { name = "git diff", cmd = "Gdiffsplit" },
        { name = "git push", cmd = "Git push" },
        { name = "git push --force", cmd = "Git push --force" },
        {
          name = "dotfiles",
          cmd = "Telescope find_files cwd=~/Dev/my/setup",
        },
        { name = "telescope builtins", cmd = "Telescope" },
        { name = "unload buffers", cmd = "%bd" },
        { name = "help", cmd = "Telescope help_tags" },
      },
    },
  },
}
telescope.load_extension "fzf"
telescope.load_extension "live_grep_args"
telescope.load_extension "file_browser"
telescope.load_extension "yacp"

map("n", "<Leader>f", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader><space>", "<Cmd>Telescope buffers<CR>")
map("n", "<Leader>s", "<Cmd>Telescope live_grep_args<CR>")
map("n", "<Leader>S", "<Cmd>Telescope grep_string<CR>")
map("n", "<Leader>F", "<Cmd>Telescope file_browser<CR>")
map("n", "<Leader>p", "<Cmd>Telescope yacp<CR>")
map("n", "@p", "<Cmd>Telescope yacp replay<CR>")
map("n", "<Leader>R", "<Cmd>Telescope lsp_references<CR>")
