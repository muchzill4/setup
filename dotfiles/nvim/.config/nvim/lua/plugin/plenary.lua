local ok, plenary = pcall(require, "plenary")

if not ok then return nil end

plenary.filetype.add_file("svelte")
