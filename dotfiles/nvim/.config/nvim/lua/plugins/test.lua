local function get_test_buf_info()
  local test_matchers = {
    { pattern = "cargo test", search = "^----.*----$" },
    { pattern = "go test", search = "FAIL:.*" },
    { pattern = "gotestsum", search = "FAIL:.*" },
    { pattern = ".bin/jest", search = nil },
    { pattern = "pytest", search = [[^_\+ .* _\+$]] },
  }
  local buf_name = vim.api.nvim_buf_get_name(0)
  for _, matcher in ipairs(test_matchers) do
    if string.find(buf_name, matcher.pattern) then
      return {
        is_test_run = true,
        matcher = matcher.pattern,
        search_pattern = matcher.search,
      }
    end
  end
  return {
    is_test_run = false,
    matcher = nil,
    search_pattern = nil,
  }
end

local function focus_first_search_match(pattern)
  vim.fn.setreg("/", pattern)
  local escaped_keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>n", true, true, true)
  vim.api.nvim_feedkeys(escaped_keys, "n", true)
end

return {
  "vim-test/vim-test",
  init = function()
    if vim.fn.executable "gotestsum" == 1 then
      vim.g["test#go#gotest#executable"] = "gotestsum --"
    end
    vim.g["test#strategy"] = "neovim"

    extend_palette {
      { name = "test suite", cmd = "TestSuite" },
    }

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
    set_test_split_size()

    vim.api.nvim_create_autocmd("TermClose", {
      group = vim.api.nvim_create_augroup("TestRunAutocloseOrFocusFirstFailure", {}),
      pattern = "*",
      callback = function()
        local test_buf_info = get_test_buf_info()
        if not test_buf_info.is_test_run then
          return
        end

        if vim.v.event["status"] == 0 then
          -- Close test window
          vim.fn.feedkeys "i"
        elseif test_buf_info.search_pattern then
          focus_first_search_match(test_buf_info.search_pattern)
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
