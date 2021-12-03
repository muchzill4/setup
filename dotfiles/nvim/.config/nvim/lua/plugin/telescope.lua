local ok, telescope = pcall(require, "telescope")

if not ok then
  return nil
end

vim.api.nvim_command [[ hi link TelescopeMatching Function ]]

local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    layout_config = { prompt_position = "top" },
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
  },
}
telescope.load_extension "fzf"
telescope.load_extension "live_grep_raw"
telescope.load_extension "dap"

local map = require("mc4.shortcuts").map

map("n", "<Leader>ff", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>")
map("n", "<Leader>ft", "<Cmd>Telescope tags<CR>")
map("n", "<Leader>fs", "<Cmd>Telescope live_grep_raw<CR>")
map("n", "<Leader>fS", "<Cmd>Telescope grep_string<CR>")
map("n", "<Leader>fx", "<Cmd>Telescope builtin<CR>")
map("n", "<Leader>gb", "<Cmd>Telescope git_branches<CR>")
map(
  "n",
  "<Leader>fd",
  "<Cmd>lua require('plugin.telescope').find_dotfiles()<CR>"
)
map("n", "<leader>ll", "<Cmd>Telescope lsp_document_diagnostics<CR>")
map("n", "<leader>lr", "<Cmd>Telescope lsp_references<CR>")

local M = {}

function M.find_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/Dev/my/setup",
  }
end

return M
