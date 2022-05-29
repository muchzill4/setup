pcall(require, "impatient")

require "mc4.maps"
require "mc4.plugins"
require "mc4.options"
require "mc4.statusline"
require "mc4.lsp"

for _, mod in ipairs(vim.api.nvim_get_runtime_file("lua/plugin/**/*.lua", true)) do
  local ok, msg = pcall(loadfile(mod))

  if not ok then
    print("Failed to load: ", mod)
    print("\t", msg)
  end
end
