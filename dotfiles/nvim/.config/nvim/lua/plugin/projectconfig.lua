local pc = prequire "nvim-projectconfig"

if pc then
  pc.setup {
    project_dir = "~/.local/share/projectconfig/",
  }
end
