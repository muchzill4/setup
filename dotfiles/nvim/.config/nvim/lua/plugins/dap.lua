local function has_dap_configured()
  local dap = prequire "dap"
  if dap then
    return dap.configurations[vim.bo.filetype] ~= nil
  end
  return false
end

return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    init = function()
      extend_palette {
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
      }
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
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
    },
    init = function()
      extend_palette {
        {
          name = "dap toggle ui",
          cmd = "lua require('dapui').toggle()",
          show = has_dap_configured,
        },
      }
    end,
  },

  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    event = { "VeryLazy" },
    config = function()
      require("dap-go").setup()
    end,
    init = function()
      extend_palette {
        {
          name = "dap debug test",
          cmd = "lua require('dap-go').debug_test()",
          show = function()
            return has_dap_configured() and vim.bo.filetype == "go"
          end,
        },
      }
    end,
  },
}
