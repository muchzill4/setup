local dap = prequire "dap"

if not dap then
  return nil
end

local dap_go = prequire "dap-go"
if dap_go then
  dap_go.setup()
end

local palette = prequire "yacp.palette"

local dapui = prequire "dapui"

if dapui then
  dapui.setup {
    controls = {
      enabled = true,
      element = "repl",
      icons = {
        pause = "pause",
        play = "play",
        step_into = "into",
        step_over = "over",
        step_out = "out",
        step_back = "back",
        run_last = "last",
        terminate = "term",
      },
    },
  }
end

local function has_dap_configured()
  return dap.configurations[vim.bo.filetype] ~= nil
end

if palette then
  palette.extend {
    {
      name = "dap continue",
      cmd = "lua require('dap').continue()",
      show = has_dap_configured,
    },
    {
      name = "dap toggle breakpoint",
      cmd = "lua require('dap').toggle_breakpoint()",
      show = has_dap_configured,
    },
    {
      name = "dap clear breakpoints",
      cmd = "lua require('dap').clear_breakpoints()",
      show = has_dap_configured,
    },
    {
      name = "dap toggle repl",
      cmd = "lua require('dap').repl.toggle()",
      show = has_dap_configured,
    },
    {
      name = "dap toggle ui",
      cmd = "lua require('dapui').toggle()",
      show = has_dap_configured,
    },
    {
      name = "dap toggle repl",
      cmd = "lua require('dap').repl.toggle()",
      show = has_dap_configured,
    },
    {
      name = "dap debug test",
      cmd = "lua require('dap-go').debug_test()",
      show = function()
        return has_dap_configured() and vim.bo.filetype == "go"
      end,
    },
  }
end
