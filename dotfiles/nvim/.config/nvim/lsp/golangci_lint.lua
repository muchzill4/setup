return {
  filetypes = { "go", "gomod" },
  root_markers = {
    ".golangci.yml",
    ".golangci.yaml",
    ".golangci.toml",
    ".golangci.json",
    "go.mod",
    "go.work",
    ".git",
  },
  cmd = { "golangci-lint-langserver" },
  init_options = {
    command = {
      "golangci-lint",
      "run",
      "--output.json.path",
      "stdout",
      "--show-stats=false",
    },
  },
}
