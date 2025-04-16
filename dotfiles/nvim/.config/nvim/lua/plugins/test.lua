local test_matchers = {
  {
    pattern = "cargo test",
    search = [[thread.*panicked at \zs.*.rs:\d\+]],
  },
  {
    pattern = "go test",
    search = [[Error Trace:\s\+\zs.*.go:\d\+]],
  },
  {
    pattern = "gotestsum",
    search = [[Error Trace:\s\+\zs.*.go:\d\+]],
  },
  { pattern = ".bin/jest" },
  { pattern = "pytest", search = [[^.*\.py:\d\+]] },
  {
    pattern = "mix test",
    search = [[\s\+\zs.*\.exs:\d\+$]],
  },
}

local function get_test_buf_info()
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
  }
end

local function focus_first_match(search_pattern)
  if type(search_pattern) == "table" then
    search_pattern = table.concat(search_pattern, "\\|")
  end
  vim.fn.setreg("/", search_pattern)

  local escaped_keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>n", true, true, true)
  vim.api.nvim_feedkeys(escaped_keys, "n", true)
end

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
      focus_first_match(test_buf_info.search_pattern)
    end
  end,
})

return {
  "vim-test/vim-test",
  init = function()
    if vim.fn.executable "gotestsum" == 1 then
      vim.g["test#go#gotest#executable"] = "gotestsum --"
    end
    vim.g["test#strategy"] = "neovim"
    vim.g["test#python#pytest#options"] = "-vv"
    -- vim.g["test#elixir#exunit#options"] = "--warnings-as-errors"

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
