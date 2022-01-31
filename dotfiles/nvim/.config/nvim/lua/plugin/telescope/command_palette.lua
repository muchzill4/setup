local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local last_cmd = nil

local palette = {
  name = "root",
  contents = {
    {
      name = "lsp",
      contents = {
        { name = "rename", cmd = "lua vim.lsp.buf.rename()" },
        { name = "references", cmd = "Telescope lsp_references" },
        { name = "diagnostics", cmd = "Telescope diagnostics bufnr=0" },
      },
    },
    {
      name = "test",
      contents = {
        { name = "file", cmd = ":TestFile" },
        { name = "suite", cmd = ":TestSuite" },
      },
    },
    -- { name="misc",
    --   contents={
    --     { name="mkdir where I am", cmd=":!mkdir -p %:p:h" },
    --   }
    -- },
    {
      name = "git",
      contents = {
        { name = "diff", cmd = "Gdiffsplit" },
        { name = "push", cmd = "Git push" },
        { name = "push --force", cmd = "Git push --force" },
      },
    },
    {
      name = "dap",
      contents = {
        { name = "continue", cmd = "lua require('dap').continue()" },
        {
          name = "toggle breakpoint",
          cmd = "lua require('dap').toggle_breakpoint()",
        },
        {
          name = "clear breakpoints",
          cmd = "lua require('dap').clear_breakpoints()",
        },
        { name = "toggle repl", cmd = "lua require('dap').repl.toggle()" },
        { name = "toggle ui", cmd = "lua require('dapui').toggle()" },
        { name = "debug test", cmd = "lua require('dap-go').debug_test()" },
      },
    },
    {
      name = "dotfiles",
      cmd = "lua require('plugin.telescope.find_dotfiles').find_dotfiles()",
      insert = true,
    },
    { name = "builtins", cmd = "Telescope builtin", insert = true },
  },
}

local function read_palette(address)
  local selected = palette
  for i = 1, #address do
    selected = selected.contents[address[i]]
  end
  return selected
end

local function command_palette(opts)
  opts = opts or {
    address = {},
  }

  local function finder(address)
    return finders.new_table {
      results = read_palette(address).contents,
      entry_maker = function(entry)
        if entry.contents then
          return {
            value = entry,
            display = entry.name .. " →",
            ordinal = entry.name,
          }
        else
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end
      end,
    }
  end

  pickers.new(opts, {
    finder = finder(opts.address),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection.value.contents then
          table.insert(opts.address, selection.index)
          current_picker:refresh(finder(opts.address), { reset_prompt = true })
        else
          actions.close(prompt_bufnr)
          last_cmd = selection.value.cmd
          if selection.value.insert then
            vim.schedule(function()
              vim.cmd "startinsert! "
            end)
          end
          vim.api.nvim_exec(selection.value.cmd, true)
        end
      end)
      return true
    end,
  }):find()
end

function M.command_palette()
  command_palette()
end

function M.command_palette_last_cmd()
  if last_cmd ~= nil then
    vim.api.nvim_exec(last_cmd, true)
  end
end

require("plenary.reload").reload_module(
  "plugin.telescope.command_palette",
  true
)

return M
