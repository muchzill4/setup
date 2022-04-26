local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local last_selection = nil

local function feed_keys(keys)
  vim.api.nvim_input(vim.api.nvim_replace_termcodes(keys, true, false, true))
end

local function run_cmd(cmd, update_errmsg)
  if update_errmsg then
    feed_keys(":" .. cmd .. "<CR>")
  else
    vim.api.nvim_command(cmd)
  end
end

function M.command_palette(opts)
  opts = opts or {}

  local function finder()
    return finders.new_table {
      results = require("plugin.telescope.palette").palette,
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
        run_cmd(selection.value.cmd, selection.value.update_errmsg)
      end)
      return true
    end,
  }):find()
end

function M.command_palette_last_cmd()
  if last_selection ~= nil then
    -- this seems to always handle errors w/o horrid feed_keys, so run_cmd isn't necessary
    run_cmd(last_selection.cmd, last_selection.update_errmsg)
  end
end

require("plenary.reload").reload_module(
  "plugin.telescope.command_palette",
  true
)

return M
