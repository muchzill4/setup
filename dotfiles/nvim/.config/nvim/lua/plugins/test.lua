return {
  "vim-test/vim-test",
  init = function()
    local function set_test_split_size()
      local test_split_size = math.floor(vim.o.lines / 3)
      if test_split_size < 20 then
        test_split_size = math.floor(vim.o.lines / 2)
      end
      vim.g["test#neovim#term_position"] = "bo " .. test_split_size
    end

    vim.api.nvim_create_autocmd("VimResized", {
      group = vim.api.nvim_create_augroup("SetTestSplitSize", {}),
      callback = set_test_split_size,
    })

    if vim.fn.executable "richgo" == 1 then
      vim.g["test#go#runner"] = "richgo"
    end

    set_test_split_size()
    vim.g["test#strategy"] = "neovim"

    extend_palette {
      { name = "test suite", cmd = "TestSuite" },
    }
  end,
  cmd = {
    "TestSuite",
  },
  keys = {
    { "<leader>l", "<Cmd>TestLast<CR>" },
    { "<leader>T", "<Cmd>TestFile<CR>" },
    { "<leader>t", "<Cmd>TestNearest<CR>" },
  },
}
