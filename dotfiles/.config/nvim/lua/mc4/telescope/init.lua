local actions = require('telescope.actions')

require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ["<c-k>"] = actions.move_selection_previous,
        ["<c-j>"] = actions.move_selection_next,
      }
    }
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    }
  }
}
require('telescope').load_extension('fzy_native')

local M = {}

function M.git_branches()
  require('telescope.builtin').git_branches {
    attach_mappings = function(_, map)
      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)
      return true
    end
  }
end

function M.edit_dotfiles()
  require('telescope.builtin').find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/Setup/dotfiles",
  }
end

return M
