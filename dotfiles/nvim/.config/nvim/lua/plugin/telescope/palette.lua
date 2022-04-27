local M = {}

M.palette = {
  { name = "lsp rename", cmd = "lua vim.lsp.buf.rename()" },
  { name = "lsp references", cmd = "Telescope lsp_references" },
  { name = "lsp diagnostics", cmd = "Telescope diagnostics" },
  { name = "test suite", cmd = "TestSuite" },
  { name = "git diff", cmd = "Gdiffsplit" },
  { name = "git push", cmd = "Git push" },
  { name = "git push --force", cmd = "Git push --force" },
  { name = "git browse", cmd = ".GBrowse" },
  { name = "git branch", cmd = "Telescope git_branches" },
  {
    name = "dap continue",
    cmd = "lua require('dap').continue()",
  },
  {
    name = "dap toggle breakpoint",
    cmd = "lua require('dap').toggle_breakpoint()",
  },
  {
    name = "dap clear breakpoints",
    cmd = "lua require('dap').clear_breakpoints()",
  },
  { name = "dap toggle repl", cmd = "lua require('dap').repl.toggle()" },
  { name = "dap toggle ui", cmd = "lua require('dapui').toggle()" },
  { name = "dap debug test", cmd = "lua require('dap-go').debug_test()" },
  {
    name = "dotfiles",
    cmd = "lua require('plugin.telescope.find_dotfiles').find_dotfiles()",
  },
  { name = "telescope builtins", cmd = "Telescope" },
  { name = "unload buffers", cmd = "%bd" },
  { name = "help", cmd = "Telescope help_tags" },
}

function M.extend(palette)
  for _, entry in ipairs(palette) do
    table.insert(M.palette, entry)
  end
end

return M
