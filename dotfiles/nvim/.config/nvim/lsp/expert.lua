return {
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  cmd = { os.getenv "HOME" .. "/.local/bin/expert" },
  root_markers = { "mix.exs" },
}
