local ok, pc = pcall(require, "nvim-projectconfig")

if not ok then
  return nil
end

pc.load_project_config {
  project_dir = "~/.local/share/projectconfig/",
}
