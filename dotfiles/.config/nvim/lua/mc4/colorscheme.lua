local cmd, fn = vim.api.nvim_command, vim.fn

local function shade(color, percent)
  local r, g, b = string.match(color, "#(%w%w)(%w%w)(%w%w)")

  local function percent_hex(hex)
    local value = tonumber(hex, 16)
    value = value * (100 + percent) / 100
    value = value < 255 and value or 255

    value = string.format("%X", value)
    if string.len(value) == 1 then
      value = "0"..value
    end
    return value
  end

  r = percent_hex(r)
  g = percent_hex(g)
  b = percent_hex(b)

  return string.format("#%s%s%s", r, g, b)
end

local colors = {
  bg     = "#1e1c31",
  fg     = "#eaeaea",
  black  = "#504f6e",
  red    = "#de5c6b",
  green  = "#7ec699",
  yellow = "#ffac45",
  blue   = "#84b8f3",
  purple = "#e0a8e1",
  cyan   = "#d2ad9b",
  white  = "#c5d3e7",
}

local mt = {}
function mt:__index(k)
  local color, operation, percent = string.match(k, "(%w+)([+-])(%d+)")
  if mt[k] == nil then
    percent = tonumber(percent, 10)
    percent = operation == "+" and percent or -1 * percent

    mt[k] = shade(colors[color], percent)
  end
  return mt[k]
end

setmetatable(colors, mt)

colors.bg_bright = colors["bg+15"]
colors.bg_brighter = colors["bg+40"]
colors.bg_brightest = colors["bg+100"]
colors.fg_dark = colors["fg-30"]

local colorscheme = {
  ColorColumn =  { bg = colors["bg+10"] },
  CursorColumn = { bg = colors.bg_bright },
  CursorLine   = { bg = colors.bg_bright },
  CursorLineNr = { fg = colors.green, bg = colors.bg_bright },
  DiffAdd      = { fg = colors.green, bg = colors["green-75"] },
  DiffChange   = { fg = colors.yellow, bg = colors["yellow-75"] },
  DiffDelete   = { fg = colors.red, bg = colors["red-75"] },
  DiffText     = { fg = colors.yellow, bg = colors["yellow-55"] },
  Directory    = { fg = colors.blue },
  EndOfBuffer  = { fg = colors.bg_brighter },
  ErrorMsg     = { fg = colors.bg, bg = colors.red },
  Folded       = { fg = colors.black },
  IncSearch    = { fg = colors.bg, bg = colors.yellow },
  LineNr       = { fg = colors.black },
  MatchParen   = { bg = colors["green-60"] },
  ModeMsg      = { fg = colors.purple, style = "bold" },
  NonText      = { fg = colors.bg_brightest },
  Normal       = { fg = colors.fg, bg = colors.bg },
  Pmenu        = { fg = colors.fg_dark, bg = colors.bg_brighter },
  PmenuSel     = { fg = colors.fg, bg = colors.bg_brightest },
  Search       = { bg = colors["yellow-65"] },
  SignColumn   = { bg = colors.bg },
  SpellBad     = { fg = colors.red, style = "underline" },
  StatusLine   = { fg = colors.fg, bg = colors.bg_brightest },
  StatusLineNC = { fg = colors.fg_dark, bg = colors.bg_brighter },
  TabLine      = { fg = colors.fg_dark, bg = colors.bg_brighter },
  TabLineFill  = { fg = colors.fg_dark, bg = colors.bg_brighter },
  TabLineSel   = { fg = colors.fg, bg = colors.bg_brightest },
  Title        = { fg = colors.cyan, style = "bold" },
  VertSplit    = { bg = colors.bg, fg = colors.bg_brighter },
  Visual       = { bg = colors.bg_brightest },

  Comment      = { fg = colors.blue, style = "italic" },

  Constant     = { fg = colors.green },
  String       = { fg = colors.cyan },

  Identifier   = { fg = colors["yellow-25"] },
  Function     = { fg = colors.yellow },

  Statement    = { fg = colors["white-15"] },

  PreProc      = { fg = colors.white },

  Type         = { fg = colors["purple"] },

  Special      = { fg = colors.white },

  Underlined   = { fg = colors.white, style = "underline" },

  Error        = { fg = colors.red },

  Todo         = { fg = colors.blue, style = "bold,italic" },

  LspDiagnosticsDefaultError         = { fg = colors.red },
  LspDiagnosticsDefaultWarning       = { fg = colors.yellow },
  LspDiagnosticsDefaultInformation   = { fg = colors.blue },
  LspDiagnosticsDefaultHint          = { fg = colors.white },
  LspDiagnosticsUnderlineError       = { fg = colors.red, style="underline" },
  LspDiagnosticsUnderlineWarning     = { fg = colors.yellow, style="underline" },
  LspDiagnosticsUnderlineInformation = { fg = colors.blue, style="underline" },
  LspDiagnosticsUnderlineHint        = { fg = colors.white, style="underline" },
  LspReferenceText  = { style = "bold,underline" },
  LspReferenceRead  = { style = "bold,underline" },
  LspReferenceWrite = { style = "bold,underline" },

  -- Diff
  diffAdded   = "DiffAdd",
  diffChanged = "DiffChange",
  diffRemoved = "DiffDelete",

  -- Statusline extras
  User1 = { fg = colors.purple, bg = colors.bg_brightest },
  User2 = { fg = colors.red, bg = colors.bg_brightest },
  User3 = { fg = colors.yellow, bg = colors.bg_brightest },
  User4 = { fg = colors.blue, bg = colors.bg_brightest },
  User5 = { fg = colors.white, bg = colors.bg_brightest },

  -- IndentBlankline
  IndentBlanklineChar = { fg=colors.bg_brightest, style="nocombine" }
}

local function highlight(group, highlight_args)
  local style = highlight_args.style or "NONE"
  local fg = highlight_args.fg or "NONE"
  local bg = highlight_args.bg or "NONE"

  cmd(string.format("hi %s gui=%s guifg=%s guibg=%s", group, style, fg, bg))
end

local function link(from, to)
  cmd(string.format("hi! link %s %s", from, to))
end

local function preamble()
  cmd("hi clear")
  if fn.exists("syntax_on") then
    cmd("syntax reset")
  end
  vim.o.background = "dark"
  vim.g.colors_name = "mc4"
end

local function apply()
  preamble()
  for group, args in pairs(colorscheme) do
    if type(args) == "table" then
      highlight(group, args)
    else
      link(group, args)
    end
  end
end

apply()
