local ok, dapui = pcall(require, "dapui")

if not ok then
  return nil
end

dapui.setup()

local map = require("mc4.shortcuts").map

map("n", "<leader>du", "<Cmd>lua require('dapui').toggle()<CR>")
