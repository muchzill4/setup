local test_runs = {
  { cmd = "cargo test", failure_pattern = "^----.*----$" },
  { cmd = "go test", failure_pattern = "FAIL:.*" },
  { cmd = "gotestsum", failure_pattern = "FAIL:.*" },
  { cmd = ".bin/jest" },
  { cmd = "pytest", failure_pattern = [[^_\+ .* _\+$]] },
  { cmd = "mix test", failure_pattern = [[^\s\+\d\+) test.*$]] },
}

local function get_test_buf_info()
  local buf_name = vim.api.nvim_buf_get_name(0)
  for _, t in ipairs(test_runs) do
    if string.find(buf_name, t.cmd) then
      return vim.tbl_extend("error", t, { is_success = vim.v.event["status"] == 0 })
    end
  end
end

local function focus_first_match(search_pattern)
  if type(search_pattern) == "table" then
    search_pattern = table.concat(search_pattern, "\\|")
  end
  vim.fn.setreg("/", search_pattern)

  local escaped_keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>n", true, true, true)
  vim.api.nvim_feedkeys(escaped_keys, "n", true)
  vim.defer_fn(function() vim.cmd "silent! nohl" end, 10) -- 10ms delay
end

vim.api.nvim_create_autocmd("TermClose", {
  group = vim.api.nvim_create_augroup("TestRunAutocloseOrFocusFirstFailure", {}),
  pattern = "*",
  callback = function()
    local test_buf_info = get_test_buf_info()
    if test_buf_info == nil or test_buf_info.is_success then
      return
    end
    focus_first_match(test_buf_info.failure_pattern)
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
