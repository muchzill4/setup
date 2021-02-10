local cmd, fn = vim.api.nvim_command, vim.fn

local function shade(color, percent)
  local r, g, b = string.match(color, '#(%w%w)(%w%w)(%w%w)')

  local function percent_hex(hex)
    local value = tonumber(hex, 16)
    value = value * (100 + percent) / 100
    value = value < 255 and value or 255

    value = string.format('%X', value)
    if string.len(value) == 1 then
      value = '0'..value
    end
    return value
  end

  r = percent_hex(r)
  g = percent_hex(g)
  b = percent_hex(b)

  return string.format('#%s%s%s', r, g, b) 
end

local colors = {
  bg     = '#1e1c31',
  fg     = '#eaeaea',
  black  = '#504f6e',
  red    = '#de5c6b',
  green  = '#7ec699',
  yellow = '#ea9d3f',
  blue   = '#6e9acb',
  purple = '#e0a8e1',
  cyan   = '#d2ad9b',
  white  = '#c5d3e7',
}

local mt = {}
function mt:__index(k)
  local color, operation, percent = string.match(k, '(%w+)([+-])(%d+)')
  if mt[k] == nil then
    percent = tonumber(percent, 10)
    percent = operation == "+" and percent or -1 * percent

    mt[k] = shade(colors[color], percent)
  end
  return mt[k]
end

setmetatable(colors, mt)

colors.bg_bright = colors['bg+20']
colors.bg_brighter = colors['bg+30']
colors.bg_brightest = colors['bg+100']
colors.fg_dark = colors['fg-30']

local colorscheme = {
  ColorColumn = { bg = colors['bg+10'] },
  CursorColumn = { bg = colors.bg_bright },
  CursorLine   = { bg = colors.bg_bright },
  CursorLineNr = { fg = colors.white, bg = colors.bg_bright },
  DiffAdd      = { fg = colors.green, bg = colors['green-75'] },
  DiffChange   = { fg = colors.yellow, bg = colors['yellow-75'] },
  DiffDelete   = { fg = colors.red, bg = colors['red-75'] },
  DiffText     = { fg = colors.yellow, bg = colors['yellow-55'] },
  Directory    = { fg = colors.blue },
  EndOfBuffer  = { fg = colors.bg_brighter },
  ErrorMsg     = { fg = colors.bg, bg = colors.red },
  Folded       = { fg = colors.black },
  IncSearch    = { fg = colors.bg, bg = colors.yellow },
  LineNr       = { fg = colors.black },
  MatchParen   = { bg = colors['blue-50'] },
  ModeMsg      = { fg = colors.purple, style = 'bold' },
  NonText      = { fg = colors.bg_brightest },
  Normal       = { fg = colors.fg, bg = colors.bg },
  Pmenu        = { fg = colors.fg_dark, bg = colors.bg_brighter },
  PmenuSel     = { fg = colors.fg, bg = colors.bg_brightest },
  Search       = { bg = colors['yellow-65'] },
  SignColumn   = { bg = colors.bg },
  SpellBad     = { fg = colors.red, style = 'underline' },
  StatusLine   = { fg = colors.fg, bg = colors.bg_brightest },
  StatusLineNC = { fg = colors.fg_dark, bg = colors.bg_brighter },
  TabLine      = { fg = colors.fg_dark, bg = colors.bg_brighter },
  TabLineFill  = { fg = colors.fg_dark, bg = colors.bg_brighter },
  TabLineSel   = { fg = colors.fg, bg = colors.bg_brightest },
  Title        = { fg = colors.cyan, style = 'bold' },
  VertSplit    = { fg = colors.bg_brighter },
  Visual       = { bg = colors.bg_brightest },

  Comment      = { fg = colors['blue+20'] },

  Constant     = { fg = colors.green },
  String       = { fg = colors.cyan },

  Identifier   = { fg = colors['yellow-15'] },
  Function     = { fg = colors['yellow+10'] },

  Statement    = { fg = colors['white-15'] },

  PreProc      = { fg = colors.white },

  Type         = { fg = colors['purple'] },

  Special      = { fg = colors.white },

  Underlined   = { fg = colors.white, style = 'underline' },

  Error        = { fg = colors.red },

  Todo         = { fg = colors['blue+40'], style = 'italic,bold' },

  LspDiagnosticsDefaultError         = { fg = colors.red },
  LspDiagnosticsDefaultWarning       = { fg = colors.yellow },
  LspDiagnosticsDefaultInformation   = { fg = colors.white },
  LspDiagnosticsDefaultHint          = { fg = colors.blue },
  LspDiagnosticsUnderlineError       = { fg = colors.red, style='underline' },
  LspDiagnosticsUnderlineWarning     = { fg = colors.yellow, style='underline' },
  LspDiagnosticsUnderlineInformation = { fg = colors.white, style='underline' },
  LspDiagnosticsUnderlineHint        = { fg = colors.blue, style='underline' },
  LspReferenceText  = { style = 'bold,underline' },
  LspReferenceRead  = { style = 'bold,underline' },
  LspReferenceWrite = { style = 'bold,underline' },

  -- Statusline extras
  User1 = { fg = colors.purple, bg = colors.bg_brightest },
  User2 = { fg = colors.red, bg = colors.bg_brightest },
  User3 = { fg = colors.yellow, bg = colors.bg_brightest },
  User4 = { fg = colors.blue, bg = colors.bg_brightest },
}

local function highlight(group, highlight_args)
  local style = highlight_args.style or 'NONE'
  local fg = highlight_args.fg or 'NONE'
  local bg = highlight_args.bg or 'NONE'

  cmd(string.format('hi %s gui=%s guifg=%s guibg=%s', group, style, fg, bg))
end

local function preamble()
  cmd('hi clear')
  if fn.exists('syntax_on') then
    cmd('syntax reset')
  end
  vim.o.background = 'dark'
  vim.g.colors_name = 'mc4'
end

local function apply()
  preamble()
  for group, args in pairs(colorscheme) do
    highlight(group, args)
  end
end

apply()
