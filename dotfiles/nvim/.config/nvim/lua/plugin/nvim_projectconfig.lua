local ok, pc = pcall(require, "nvim-projectconfig")

if not ok then
  return nil
end

pc.setup {
  project_dir = "~/.local/share/projectconfig/",
}
