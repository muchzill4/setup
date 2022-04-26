local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local last_selection = nil

local palette = {
  { name = "lsp rename", cmd = "lua vim.lsp.buf.rename()" },
  { name = "lsp references", cmd = "Telescope lsp_references" },
  { name = "lsp diagnostics", cmd = "Telescope diagnostics" },
  { name = "test suite", cmd = "TestSuite", can_error = true },
  { name = "git diff", cmd = "Gdiffsplit" },
  { name = "git push", cmd = "Git push" },
  { name = "git push --force", cmd = "Git push --force" },
  { name = "git browse", cmd = ".GBrowse" },
  { name = "git branch", cmd = "Telescope git_branches" },
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
  { name = "dap debug test", cmd = "lua require('dap-go').debug_test()" },
  {
    name = "dotfiles",
    cmd = "lua require('plugin.telescope.find_dotfiles').find_dotfiles()",
  },
  { name = "telescope builtins", cmd = "Telescope" },
  { name = "unload buffers", cmd = "%bd" },
}

local function feed_keys(keys)
  vim.api.nvim_input(vim.api.nvim_replace_termcodes(keys, true, false, true))
end

local function run_cmd(cmd, can_error)
  if can_error then
    feed_keys(":" .. cmd .. "<CR>")
  else
    vim.api.nvim_command(cmd)
  end
end

local function command_palette(opts)
  opts = opts or {}

  local function finder()
    return finders.new_table {
      results = palette,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    }
  end

  pickers.new(opts, {
    prompt_title = "Command palette",
    finder = finder(),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        last_selection = selection.value
        run_cmd(selection.value.cmd, selection.value.can_error)
      end)
      return true
    end,
  }):find()
end

function M.command_palette()
  command_palette()
end

function M.command_palette_last_cmd()
  if last_selection ~= nil then
    -- this seems to always work w/o horrid feed_keys, so run_cmd isn't necessary
    run_cmd(last_selection.cmd, last_selection.can_error)
  end
end

require("plenary.reload").reload_module(
  "plugin.telescope.command_palette",
  true
)

return M
