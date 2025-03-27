return {
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  cmd = { os.getenv "HOME" .. "/Dev/vcs/elixir-ls/language_server.sh" },
  root_markers = { "mix.exs" },
}
