local M = {}

function M.shade(color, percent)
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

return M
