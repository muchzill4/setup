local M = {}

function M.find_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    shorten_path = false,
    cwd = "~/Dev/my/setup",
  }
end

return M
