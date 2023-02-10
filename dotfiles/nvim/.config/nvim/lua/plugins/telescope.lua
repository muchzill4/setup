return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { dir = "~/Dev/my/telescope-yacp.nvim" },
  },
  config = function()
    local telescope = require "telescope"

    local actions = require "telescope.actions"
    local lga_actions = require "telescope-live-grep-args.actions"

    telescope.setup {
      defaults = {
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
  end,
  keys = {
    { "<Leader>f", "<Cmd>Telescope find_files<CR>" },
    { "<Leader><space>", "<Cmd>Telescope buffers<CR>" },
    { "<Leader>s", "<Cmd>Telescope live_grep_args<CR>" },
    {
      "<Leader>S",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args {
          default_text = vim.fn.expand "<cword>",
        }
      end,
    },
    { "<Leader>F", "<Cmd>Telescope file_browser hidden=true<CR>" },
    { "<Leader>p", "<Cmd>Telescope yacp<CR>" },
    { "@p", "<Cmd>Telescope yacp replay<CR>" },
    {
      "<Leader>R",
      "<Cmd>Telescope lsp_references include_current_line=true<CR>",
    },
    { "<Leader>h", "<Cmd>Telescope help_tags<CR>" },
    { "<leader>d", "<Cmd>Telescope diagnostics bufnr=0<CR>" },
    { "<leader>D", "<Cmd>Telescope diagnostics<CR>" },
    { "<leader>j", "<Cmd>Telescope lsp_document_symbols<CR>" },
    { "<leader>J", "<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>" },
    { "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>" },
  },
}
