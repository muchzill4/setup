local directions = {
  h = "left",
  j = "down",
  k = "up",
  l = "right",
}

local function navigate(direction)
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. direction)
  if vim.api.nvim_get_current_win() == win then
    vim.system({ "rex", "focus", directions[direction] })
  end
end

for key in pairs(directions) do
  vim.keymap.set("n", "<C-" .. key .. ">", function() navigate(key) end, { silent = true })
end
