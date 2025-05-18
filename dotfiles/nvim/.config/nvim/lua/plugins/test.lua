local test_runs = {
  {
    cmd = "cargo test",
    failing_test_pattern = "^----.*----$",
  },
  {
    cmd = "go test",
    failing_test_pattern = "FAIL:.*",
  },
  {
    cmd = "gotestsum",
    failing_test_pattern = "FAIL:.*",
  },
  { cmd = ".bin/jest" },
  {
    cmd = "pytest",
    failing_test_pattern = [[^_\+ .* _\+$]],
  },
  {
    cmd = "mix test",
    failing_test_pattern = [[^\s\+\d\+) test.*$]],
    file_location_pattern = [[\s\+\zs.*\.exs:\d\+]],
  },
}

local function get_test_run_info(cmd, status_code)
  for _, t in ipairs(test_runs) do
    if string.find(cmd, t.cmd) then
      return vim.tbl_extend("error", t, { has_failing_tests = status_code ~= 0 })
    end
  end
end

local function focus_first_match(pattern)
  local escaped_keys = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true)
  vim.api.nvim_feedkeys(escaped_keys, "n", true)
  vim.defer_fn(function() vim.fn.search(pattern) end, 10)
end

local function setup_navigation_shortcuts(buffer, test_run_info)
  local opts = { noremap = true, silent = true, buffer = buffer }
  if test_run_info.failing_test_pattern then
    map("n", "]t", function() vim.fn.search(test_run_info.failing_test_pattern) end, opts)
    map("n", "[t", function() vim.fn.search(test_run_info.failing_test_pattern, "b") end, opts)
  end
  if test_run_info.file_location_pattern then
    map("n", "]f", function() vim.fn.search(test_run_info.file_location_pattern) end, opts)
    map("n", "[f", function() vim.fn.search(test_run_info.file_location_pattern, "b") end, opts)
  end
end

vim.api.nvim_create_autocmd("TermClose", {
  group = vim.api.nvim_create_augroup("TestRunAutocloseOrFocusFirstFailure", {}),
  pattern = "term://*",
  callback = function(args)
    local cmd = args["file"]
    local status_code = vim.v.event["status"]
    local test_run_info = get_test_run_info(cmd, status_code)
    if test_run_info == nil then
      return
    end

    if test_run_info.has_failing_tests then
      focus_first_match(test_run_info.failing_test_pattern)
      setup_navigation_shortcuts(args.buf, test_run_info)
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
