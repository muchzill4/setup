local gs = prequire "gitsigns"

if not gs then
  return
end

gs.setup {
  on_attach = function(bufnr)
    local opts = { buffer = bufnr, expr = true }

    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, opts)

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, opts)
  end,
}
