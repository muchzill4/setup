local terminal = "com.superlogical.terminal"

local function is_vim(ctx)
  local process = rex.block.call(terminal, "process", {
    block_id = ctx.block_id,
  })
  if not process then
    return false
  end
  local name = process.foreground and process.foreground.name
  return name == "nvim" or name == "vim"
end

local directions = {
  ["ctrl+h"] = "left",
  ["ctrl+j"] = "down",
  ["ctrl+k"] = "up",
  ["ctrl+l"] = "right",
}

for key, direction in pairs(directions) do
  rex.bind(key, function(ctx)
    if is_vim(ctx) then
      return false
    end
    rex.session.focus_direction { direction = direction }
    return true
  end)
end
