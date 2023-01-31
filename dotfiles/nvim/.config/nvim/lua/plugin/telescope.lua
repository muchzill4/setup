local telescope = prequire "telescope"

if not telescope then
  return nil
end

local actions = require "telescope.actions"
local lga_actions = require "telescope-live-grep-args.actions"

telescope.setup {
  defaults = {
    winblend = 5,
    dynamic_preview_title = true,
    layout_strategy = "vertical",
    layout_config = {
      prompt_position = "top",
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
    live_grep_args = {
      auto_quoting = true,
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
        },
      },
    },
    yacp = {
      palette = {
        require("yacp.focus").palette_entry,
        { name = "test suite", cmd = "TestSuite" },
        { name = "git browse", cmd = ".GBrowse" },
        { name = "git blame", cmd = "Git blame" },
        { name = "git branch", cmd = "Telescope git_branches" },
        { name = "git log", cmd = "Git log --oneline -100" },
        { name = "git buffer log", cmd = "Git log --oneline -100 %" },
        { name = "git diff", cmd = "Gdiffsplit!" },
        { name = "git push", cmd = "Git push" },
        { name = "git push --force", cmd = "Git push --force" },
        {
          name = "markdown preview",
          cmd = "MarkdownPreview",
          show = function()
            return vim.bo.filetype == "markdown"
          end,
        },
        {
          name = "setup / dotfiles",
          cmd = "Telescope find_files cwd=~/Dev/my/setup",
        },
        { name = "telescope builtins", cmd = "Telescope" },
        { name = "unload buffers", cmd = "%bd|edit#|bd#" },
        {
          name = "vim keymaps",
          cmd = "Telescope keymaps",
        },
        { name = "vim help", cmd = "Telescope help_tags" },
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
map("n", "<Leader>S", function()
  require("telescope").extensions.live_grep_args.live_grep_args {
    default_text = vim.fn.expand "<cword>",
  }
end)
map("n", "<Leader>F", "<Cmd>Telescope file_browser hidden=true<CR>")
map("n", "<Leader>p", "<Cmd>Telescope yacp<CR>")
map("n", "@p", "<Cmd>Telescope yacp replay<CR>")
map(
  "n",
  "<Leader>R",
  "<Cmd>Telescope lsp_references include_current_line=true<CR>"
)
map("n", "<Leader>h", "<Cmd>Telescope help_tags<CR>")
map("n", "<leader>d", "<Cmd>Telescope diagnostics bufnr=0<CR>")
map("n", "<leader>D", "<Cmd>Telescope diagnostics<CR>")
map("n", "<leader>j", "<Cmd>Telescope lsp_document_symbols<CR>")
map("n", "<leader>J", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>")
map("n", "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>")
