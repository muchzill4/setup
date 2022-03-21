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
    file_browser = {
      grouped = true,
      sorting_strategy = 'ascending',
      path = '%:p:h',
    },
  },
}
telescope.load_extension "fzf"
telescope.load_extension "live_grep_raw"
telescope.load_extension "dap"
telescope.load_extension "file_browser"

local map = require("mc4.shortcuts").map

map("n", "<Leader>f", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader>b", "<Cmd>Telescope buffers<CR>")
map("n", "<Leader>s", "<Cmd>Telescope live_grep_raw<CR>")
map("n", "<Leader>S", "<Cmd>Telescope grep_string<CR>")
map("n", "<Leader>F", "<Cmd>Telescope file_browser<CR>")
map(
  "n",
  "<Leader>p",
  "<Cmd>lua require('plugin.telescope.command_palette').command_palette()<CR>"
)
map(
  "n",
  "<Leader>P",
  "<Cmd>lua require('plugin.telescope.command_palette').command_palette_last_cmd()<CR>"
)
