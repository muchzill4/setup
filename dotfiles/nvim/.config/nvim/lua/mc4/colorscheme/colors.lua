local utils = require("mc4.colorscheme.utils")

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

    mt[k] = utils.shade(colors[color], percent)
  end
  return mt[k]
end

setmetatable(colors, mt)

colors.bg_bright = colors["bg+15"]
colors.bg_brighter = colors["bg+40"]
colors.bg_brightest = colors["bg+100"]
colors.fg_dark = colors["fg-30"]

return colors
