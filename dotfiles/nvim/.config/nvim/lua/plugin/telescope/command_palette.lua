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
    { name = "lsp rename", cmd = "lua vim.lsp.buf.rename()" },
    { name = "lsp references", cmd = "Telescope lsp_references" },
    { name = "lsp diagnostics", cmd = "Telescope diagnostics bufnr=0" },
    { name = "test file", cmd = ":TestFile", insert = true },
    { name = "test suite", cmd = ":TestSuite", insert = true },
  --     { name="mkdir where I am", cmd=":!mkdir -p %:p:h" },
    { name = "git diff", cmd = "Gdiffsplit" },
    { name = "git push", cmd = "Git push" },
    { name = "git push --force", cmd = "Git push --force" },
    { name = "git browse", cmd = ".GBrowse" },
    { name = "dap continue", cmd = "lua require('dap').continue()", insert = true },
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
      insert = true,
    },
    { name = "telescope builtins", cmd = "Telescope builtin", insert = true },
    { name = "unload buffers", cmd = "%bd" },
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
          vim.api.nvim_command(selection.value.cmd)
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
    vim.api.nvim_command(last_cmd)
  end
end

require("plenary.reload").reload_module(
  "plugin.telescope.command_palette",
  true
)

return M
