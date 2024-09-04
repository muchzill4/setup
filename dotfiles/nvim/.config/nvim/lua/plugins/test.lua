local function is_test_run_buf()
  local test_matchers = { "go test", "richgo test", "gotestsum", ".bin/jest" }
  local buf_name = vim.api.nvim_buf_get_name(0)
  for _, matcher in ipairs(test_matchers) do
    if string.find(buf_name, matcher) then
      return true
    end
  end
  return false
end

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

    if vim.fn.executable "gotestsum" == 1 then
      vim.g["test#go#runner"] = "gotest"
      vim.g["test#go#gotest#executable"] = "gotestsum --"
    elseif vim.fn.executable "richgo" == 1 then
      vim.g["test#go#runner"] = "richgo"
    end

    set_test_split_size()
    vim.g["test#strategy"] = "neovim"

    extend_palette {
      { name = "test suite", cmd = "TestSuite" },
    }

    -- Autoclose test run terminal when status is 0
    vim.api.nvim_create_autocmd("TermClose", {
      group = vim.api.nvim_create_augroup("TerminalCloseOnTestRunSuccess", {}),
      pattern = "*",
      callback = function()
        if is_test_run_buf() and vim.v.event["status"] == 0 then
          vim.fn.feedkeys "i"
        end
      end,
    })
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
