local function has_dap_configured()
  local dap = prequire "dap"
  if dap then
    return dap.configurations[vim.bo.filetype] ~= nil
  end
  return false
end

local function starts_with_prefix(s, prefix) return string.sub(s, 1, string.len(prefix)) == prefix end

local function is_dap_window()
  return starts_with_prefix(vim.bo.filetype, "dapui_")
    or starts_with_prefix(vim.bo.filetype, "dap-")
end

return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      extend_palette {
        {
          name = "dap continue",
          cmd = function() require("dap").continue() end,
          show = has_dap_configured,
        },
        {
          name = "dap toggle breakpoint",
          cmd = function() require("dap").toggle_breakpoint() end,
          show = has_dap_configured,
        },
        {
          name = "dap list breakpoints",
          cmd = function() require("fzf-lua").dap_breakpoints() end,
          show = has_dap_configured,
        },
        {
          name = "dap clear breakpoints",
          cmd = function() require("dap").clear_breakpoints() end,
          show = has_dap_configured,
        },
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      icons = {
        expanded = "▾",
        collapsed = "▸",
        current_frame = ">",
      },
      controls = {
        enabled = true,
        element = "repl",
        icons = {
          pause = "⏸ ",
          play = "▶",
          step_into = "↧",
          step_over = "↷",
          step_out = "↥",
          step_back = "↤",
          run_last = "↻",
          terminate = "▣",
        },
      },
      expand_lines = false,
      layouts = {
        {
          elements = {
            {
              id = "scopes",
              size = 0.50,
            },
            {
              id = "breakpoints",
              size = 0.10,
            },
            {
              id = "stacks",
              size = 0.15,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "left",
          size = 80,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    init = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
      extend_palette {
        {
          name = "dap toggle ui",
          cmd = function() require("dapui").toggle() end,
          show = function() return has_dap_configured() or is_dap_window() end,
        },
      }
    end,
  },

  {
    "muchzill4/nvim-dap-go", -- Configurations for launching delve and debugging individual tests
    branch = "future",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function() require("dap-go").setup() end,
    init = function()
      extend_palette {
        {
          name = "dap debug test",
          cmd = function() require("dap-go").debug_test() end,
          show = function() return has_dap_configured() and vim.bo.filetype == "go" end,
        },
      }
    end,
  },
}
