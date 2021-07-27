local cmd, fn = vim.api.nvim_command, vim.fn
local colors = require('mc4.colorscheme.colors')

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
  LspDiagnosticsUnderlineError       = { fg = colors.red, style="undercurl" },
  LspDiagnosticsUnderlineWarning     = { fg = colors.yellow, style="undercurl" },
  LspDiagnosticsUnderlineInformation = { fg = colors.blue, style="undercurl" },
  LspDiagnosticsUnderlineHint        = { fg = colors.white, style="undercurl" },
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
  IndentBlanklineChar = { fg=colors.bg_brightest, style="nocombine" },

  -- Signify
  SignifySignAdd = { fg = colors.green },
  SignifySignChange = { fg = colors.yellow },
  SignifySignDelete = { fg = colors.red },
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
