local ok, telescope = pcall(require, "telescope")

if not ok then
  return nil
end

vim.api.nvim_command [[ hi link TelescopeMatching Function ]]

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    layout_config = { prompt_position = "top", width = 0.9 },
    sorting_strategy = "ascending",
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
    },
    yacp = {
      palette = {
        require("yacp.focus").palette_entry,
        { name = "lsp references", cmd = "Telescope lsp_references" },
        { name = "lsp diagnostics", cmd = "Telescope diagnostics" },
        { name = "test suite", cmd = "TestSuite" },
        { name = "git browse", cmd = ".GBrowse" },
        { name = "git branch", cmd = "Telescope git_branches" },
        { name = "git bcommits", cmd = "Telescope git_bcommits" },
        { name = "git commits", cmd = "Telescope git_commits" },
        { name = "git diff", cmd = "Gdiffsplit" },
        { name = "git push", cmd = "Git push" },
        { name = "git push --force", cmd = "Git push --force" },
        {
          name = "dap continue",
          cmd = "lua require('dap').continue()",
        },
        {
          name = "dap toggle breakpoint",
          cmd = "lua require('dap').toggle_breakpoint()",
        },
        {
          name = "dap clear breakpoints",
          cmd = "lua require('dap').clear_breakpoints()",
        },
        { name = "dap toggle repl", cmd = "lua require('dap').repl.toggle()" },
        { name = "dap toggle ui", cmd = "lua require('dapui').toggle()" },
        {
          name = "dap debug test",
          cmd = "lua require('dap-go').debug_test()",
        },
        {
          name = "dotfiles",
          cmd = "lua require('plugin.telescope.find_dotfiles').find_dotfiles()",
        },
        { name = "telescope builtins", cmd = "Telescope" },
        { name = "unload buffers", cmd = "%bd" },
        { name = "help", cmd = "Telescope help_tags" },
      },
    },
  },
}
telescope.load_extension "fzf"
telescope.load_extension "live_grep_raw"
telescope.load_extension "dap"
telescope.load_extension "file_browser"
telescope.load_extension "aerial"
telescope.load_extension "yacp"

local map = require("mc4.shortcuts").map

map("n", "<Leader>f", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader>b", "<Cmd>Telescope buffers<CR>")
map("n", "<Leader>s", "<Cmd>Telescope live_grep_raw<CR>")
map("n", "<Leader>S", "<Cmd>Telescope grep_string<CR>")
map("n", "<Leader>F", "<Cmd>Telescope file_browser<CR>")
map("n", "<Leader>a", "<Cmd>Telescope aerial<CR>")
map("n", "<Leader>p", "<Cmd>Telescope yacp<CR>")
map("n", "<Leader>P", "<Cmd>Telescope yacp replay<CR>")
