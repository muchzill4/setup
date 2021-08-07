local ok, lualine = pcall(require, "lualine")

if not ok then return nil end

local colors = require("doubletrouble")

local function obsession_status()
  local status = vim.fn.ObsessionStatus()
  if status == "[$]" then
    return "⊙"
  end
  return ""
end

lualine.setup({
  sections = {
    lualine_a = {{"mode", lower = true}},
    lualine_b = {
      {"filetype", disable_text = true, right_padding = 0},
      {"filename", path = 1}
    },
    lualine_c = {},
    lualine_x = {
      {
        "diagnostics",
        sources = {"nvim_lsp"},
        symbols = {error = "E:", warn = "W:", info = "I:", hint = "H:"}
      }
    },
    lualine_y = {"branch"},
    lualine_z = {"location", {obsession_status, color = {fg = colors.red}}}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {{"filename", path = 1}},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {"location"}
  },
  options = {
    section_separators = "",
    component_separators = "",
    theme = {
      normal = {
        a = {bg = colors["black+60"], fg = colors.bg},
        b = {bg = colors.bg_brightest, fg = colors.fg},
        c = {bg = colors.bg_brightest, fg = colors.fg},
        y = {bg = colors.bg_brightest, fg = colors.purple},
        z = {bg = colors.bg_brightest, fg = colors.fg}
      },
      insert = {a = {bg = colors.green, fg = colors.bg}},
      visual = {a = {bg = colors.yellow, fg = colors.bg}},
      replace = {a = {bg = colors.cyan, fg = colors.bg}},
      command = {a = {bg = colors.purple, fg = colors.bg}},
      inactive = {
        a = {fg = colors.fg_dark, bg = colors.bg_brighter},
        b = {fg = colors.fg_dark, bg = colors.bg_brighter},
        c = {fg = colors.fg_dark, bg = colors.bg_brighter},
        x = {fg = colors.fg_dark, bg = colors.bg_brighter},
        y = {fg = colors.fg_dark, bg = colors.bg_brighter},
        z = {fg = colors.fg_dark, bg = colors.bg_brighter}
      }
    }
  }
})
