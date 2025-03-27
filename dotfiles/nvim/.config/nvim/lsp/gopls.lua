return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.mod", "go.work" },
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      semanticTokens = true,
      usePlaceholders = true,
      analyses = {
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
      },
    },
  },
}
