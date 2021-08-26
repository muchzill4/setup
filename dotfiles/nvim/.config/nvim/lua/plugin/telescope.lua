local ok, telescope = pcall(require, "telescope")

if not ok then return nil end

local actions = require("telescope.actions")

telescope.setup {
  defaults = {
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    mappings = {
      i = {
        ["<c-k>"] = actions.move_selection_previous,
        ["<c-j>"] = actions.move_selection_next
      }
    }
  },
  pickers = {
    buffers = {
      previewer = false,
      mappings = {
        i = {
          ["<c-d>"] = actions.delete_buffer
        },
        n = {
          ["<c-d>"] = actions.delete_buffer
        }
      }
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case"
    }
  }
}
require("telescope").load_extension("fzf")


local map = require("mc4.shortcuts").map

map("n", "<Leader>ff", "<Cmd>Telescope find_files<CR>")
map("n", "<Leader>fb", "<Cmd>Telescope buffers<CR>")
map("n", "<Leader>ft", "<Cmd>Telescope tags<CR>")
map("n", "<Leader>fs", "<Cmd>Telescope live_grep<CR>")
map("n", "<Leader>fS", "<Cmd>Telescope grep_string<CR>")
map("n", "<Leader>fx", "<Cmd>Telescope builtin<CR>")
map("n", "<Leader>gb", "<Cmd>Telescope git_branches<CR>")
map("n", "<Leader>fd", "<Cmd>lua require('plugin.telescope').find_dotfiles()<CR>")
map("n", "<leader>ll", "<Cmd>Telescope lsp_document_diagnostics<CR>")

local M = {}

function M.find_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/Dev/personal/setup"
  }
end

return M
