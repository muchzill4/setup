-- vim: foldmethod=marker
-- Options {{{
vim.opt.expandtab = true
local indent = 2
vim.opt.shiftwidth = indent
vim.opt.tabstop = indent
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "

vim.opt.clipboard = "unnamed"

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.mouse = "nv"

vim.opt.scrolloff = 4

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tags:append { ".git/tags" }

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.undofile = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.signcolumn = "yes"

vim.opt.completeopt = "menuone,noselect,popup"
vim.opt.autocomplete = true
vim.opt.complete = ".^5,w^5,b^5,u^5"

vim.opt.wildmode = "longest:full,full"

vim.opt.exrc = true

vim.opt.winborder = "rounded"

vim.opt.switchbuf = "useopen"

vim.opt.foldnestmax = 3
vim.opt.foldminlines = 4
vim.opt.foldlevel = 99

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if not pcall(vim.treesitter.start, args.buf) then
      return
    end
    vim.bo.indentexpr = "v:lua.vim.treesitter.indentexpr()"
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightOnYank", {}),
  pattern = "*",
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ResizeSplitsOnWinResize", {}),
  pattern = "*",
  command = "wincmd =",
})

vim.opt.cursorline = true
local set_cursorline_group = vim.api.nvim_create_augroup("CursorLineControl", {})
local set_cursorline = function(event, value)
  vim.api.nvim_create_autocmd(event, {
    group = set_cursorline_group,
    callback = function() vim.opt_local.cursorline = value end,
  })
end
set_cursorline("WinLeave", false)
set_cursorline("WinEnter", true)

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("AutoInsertInTerminal", {}),
  command = "startinsert",
})
-- }}}
-- Keymaps {{{
local map = vim.keymap.set

map("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

map("t", "<Esc>", "<C-\\><C-n>")
map("t", "<C-[>", "<C-\\><C-n>")

map("n", "<Leader>w", "<Cmd>w<CR>")

map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")
map("n", "J", "mzJ`z")
map("n", "<C-o>", "<C-o>zz")
map("n", "<C-i>", "<C-i>zz")

map("n", "j", [[(v:count >= 5 ? "m'" . v:count : "") . "j"]], { expr = true })
map("n", "k", [[(v:count >= 5 ? "m'" . v:count : "") . "k"]], { expr = true })

map("n", "<Esc>", "<Cmd>nohlsearch<CR>")

map({ "i", "s" }, "<Esc>", function()
  vim.snippet.stop()
  return "<Esc>"
end, { expr = true })
-- }}}
-- Commands {{{
vim.api.nvim_create_user_command("W", "w", {})
-- }}}
-- Plugins {{{
--- colorscheme {{{
-- vim.pack.add { "https://github.com/muchzill4/doubletrouble" }
vim.opt.rtp:prepend(vim.fn.expand "~/Dev/my/doubletrouble")
vim.cmd "colorscheme doubletrouble"
--- }}}
--- yacp {{{
vim.pack.add { "https://github.com/muchzill4/yacp.nvim" }
require("yacp").setup {
  palette = {
    {
      name = "setup / dotfiles",
      cmd = function() require("fzf-lua").files { cwd = "~/Dev/my/setup" } end,
    },
    { name = "unload buffers", cmd = "%bd|edit#|bd#" },
    { name = "pack update", cmd = function() vim.pack.update() end },
    {
      name = "pack update (plugin)",
      cmd = function()
        local names = vim.tbl_map(function(p) return p.spec.name end, vim.pack.get())
        require("fzf-lua").fzf_exec(names, {
          actions = { ["default"] = function(selected) vim.pack.update(selected) end },
        })
      end,
    },
  },
  enable_focus = true,
}
map("n", "<Leader>p", function() require("yacp").yacp() end)
map("v", "<Leader>p", function() require("yacp").yacp() end)
map("n", "@p", function() require("yacp").replay() end)

local extend_palette = function(entries) require("yacp.palette").extend(entries) end
--- }}}
--- misc {{{
vim.pack.add {
  "https://github.com/tpope/vim-eunuch",
  "https://github.com/tpope/vim-unimpaired",
  "https://github.com/tpope/vim-surround",
}

vim.pack.add { "https://github.com/tpope/vim-projectionist" }
vim.g["projectionist_heuristics"] = {
  ["go.mod"] = {
    ["*.go"] = {
      type = "source",
      alternate = "{}_test.go",
    },
    ["*_test.go"] = {
      type = "test",
      alternate = "{}.go",
    },
  },
  ["Cargo.toml"] = {
    ["*.rs"] = {
      type = "source",
      alternate = "{}_tests.rs",
    },
    ["*_tests.rs"] = {
      type = "test",
      alternate = "{}.rs",
    },
  },
  ["package.json"] = {
    ["*.ts"] = {
      type = "source",
      alternate = "{}.test.ts",
    },
    ["*.test.ts"] = {
      type = "test",
      alternate = "{}.ts",
    },
    ["*.tsx"] = {
      type = "source",
      alternate = "{}.test.tsx",
    },
    ["*.test.tsx"] = {
      type = "test",
      alternate = "{}.tsx",
    },
  },
  ["requirements.txt|pyproject.toml|uv.lock"] = {
    ["*.py"] = {
      type = "source",
      alternate = "test_{}.py",
    },
    ["test_*.py"] = {
      type = "test",
      alternate = "{}.py",
    },
  },
  ["mix.exs"] = {
    ["lib/*.ex"] = {
      type = "source",
      alternate = "test/{}_test.exs",
    },
    ["test/*_test.exs"] = {
      type = "test",
      alternate = "lib/{}.ex",
    },
  },
}

vim.pack.add { "https://github.com/christoomey/vim-tmux-navigator" }

vim.pack.add { "https://github.com/itspriddle/vim-marked" }
extend_palette {
  {
    name = "markdown preview",
    cmd = "MarkedOpen!",
    show = function() return vim.bo.filetype == "markdown" end,
  },
}

vim.pack.add { "https://github.com/stevearc/oil.nvim" }
require("oil").setup {
  keymaps = {
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-h>"] = false,
    ["<C-l>"] = false,
  },
  view_options = {
    show_hidden = true,
  },
}

map("n", "-", "<Cmd>Oil<CR>")

vim.pack.add { "https://github.com/j-hui/fidget.nvim" }
require("fidget").setup()
--- }}}
--- fzf {{{
vim.pack.add { "https://github.com/ibhagwan/fzf-lua" }
local fzf_lua = require "fzf-lua"
fzf_lua.setup {
  winopts = {
    backdrop = 100,
    preview = {
      layout = "vertical",
    },
  },
  keymap = {
    builtin = {
      ["<C-/>"] = "toggle-help",
      ["<C-d>"] = "preview-page-down",
      ["<C-u>"] = "preview-page-up",
    },
  },
  grep = {
    rg_glob = true,
    glob_flag = "--iglob",
    glob_separator = "%s%-%-",
    RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
  },
}
fzf_lua.register_ui_select()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("FzFLuaLsp", {}),
  callback = function(args)
    local mopts = { buffer = args.buf }
    map("n", "<leader>d", function() require("fzf-lua").diagnostics_document() end, mopts)
    map("n", "<leader>D", function() require("fzf-lua").diagnostics_workspace() end, mopts)
    map("n", "<leader>j", function() require("fzf-lua").lsp_document_symbols() end)
    map("n", "<leader>J", function() require("fzf-lua").lsp_live_workspace_symbols() end, mopts)
    map("n", "grr", function() require("fzf-lua").lsp_references() end)
    map("n", "gri", function() require("fzf-lua").lsp_implementations() end)
  end,
})

map("n", "<Leader><space>", function() require("fzf-lua").buffers() end)
map("n", "<Leader>h", function() require("fzf-lua").help_tags() end)
map("n", "<Leader>f", function() require("fzf-lua").files() end)
map("n", "<Leader>F", function() require("fzf-lua").files { cwd = "%:p:h" } end)
map("n", "<leader>P", function() require("fzf-lua").builtin() end)
map("n", "<Leader>s", function() require("fzf-lua").live_grep() end)
map("n", "<Leader>S", function() require("fzf-lua").grep_cword() end)
--- }}}
--- git {{{
vim.pack.add { "https://github.com/tpope/vim-fugitive" }
map("n", "<leader>g", "<Cmd>Git<CR>")
extend_palette {
  { name = "git blame", cmd = "Git blame" },
  { name = "git log", cmd = "Git log --oneline -100" },
  { name = "git file log", cmd = "Git log --oneline -100 %" },
  { name = "git diff current file", cmd = "Gvdiffsplit!" },
  { name = "git diff default branch", cmd = "Git difftool -y origin/HEAD" },
  {
    name = "git difftool close",
    cmd = function()
      for i = vim.fn.tabpagenr "$", 1, -1 do
        if vim.fn.gettabwinvar(i, 1, "&diff") == 1 then
          vim.cmd("tabclose " .. i)
        end
      end
    end,
  },
  { name = "git push", cmd = "Git push" },
  { name = "git push --force", cmd = "Git push --force" },
}

vim.pack.add { "https://github.com/tpope/vim-rhubarb" }
extend_palette {
  { name = "git browse", cmd = ".GBrowse" },
  {
    name = "github pull request",
    cmd = "!gh pr create --web --head (git branch --show-current)",
  },
}

vim.pack.add { "https://github.com/lewis6991/gitsigns.nvim" }
require("gitsigns").setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local opts = { buffer = bufnr, expr = true }

    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function() gs.next_hunk() end)
      return "<Ignore>"
    end, opts)

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function() gs.prev_hunk() end)
      return "<Ignore>"
    end, opts)
  end,
}
--- }}}
--- format {{{
vim.pack.add { "https://github.com/stevearc/conform.nvim" }
require("conform").setup {
  formatters_by_ft = {
    lua = { "stylua" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    markdown = { "biome" },
    json = { "biome" },
    yaml = { "biome" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_fallback = true }
  end,
}
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})
--- }}}
--- test {{{
vim.pack.add { "https://github.com/vim-test/vim-test" }
vim.g["test#go#gotest#options"] = "-v"
vim.g["test#strategy"] = "neovim"
vim.g["test#python#pytest#options"] = "-vv"

map("n", "<leader>l", "<Cmd>TestLast<CR>")
map("n", "<leader>T", "<Cmd>TestFile<CR>")
map("n", "<leader>t", "<Cmd>TestNearest<CR>")

extend_palette {
  { name = "test suite", cmd = "TestSuite" },
}

local test_runs = {
  { cmd = "cargo test", failing_test_pattern = "^----.*----$" },
  { cmd = "go test", failing_test_pattern = "FAIL:.*" },
  { cmd = "gotestsum", failing_test_pattern = "FAIL:.*" },
  { cmd = ".bin/jest" },
  { cmd = "pytest", failing_test_pattern = [[^_\+ .* _\+$]] },
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
    else
      vim.fn.feedkeys "i"
    end
  end,
})
--- }}}
--- treesitter {{{
vim.pack.add {
  { src = "https://github.com/romus204/tree-sitter-manager.nvim" },
}
require("tree-sitter-manager").setup {
  ensure_installed = {
    "bash",
    "comment",
    "fish",
    "go",
    "gomod",
    "gowork",
    "javascript",
    "make",
    "python",
    "yaml",
  },
}

vim.pack.add { "https://github.com/nvim-treesitter/nvim-treesitter-context" }
require("treesitter-context").setup {
  multiwindow = true,
}
--- }}}
-- }}}
-- LSP {{{
vim.diagnostic.config {
  float = { severity_sort = true },
  jump = { float = true },
}

-- don't attach lsp to fugitive buffers
vim.lsp.start = (function()
  local original_start = vim.lsp.start
  return function(config, opts, ...)
    local bufnr = opts and opts.bufnr
    if bufnr then
      local is_invalid = not vim.api.nvim_buf_is_valid(bufnr)
      local is_fugitive = vim.b[bufnr].fugitive_type
        or vim.startswith(vim.api.nvim_buf_get_name(bufnr), "fugitive://")
      if is_invalid or is_fugitive then
        return
      end
    end
    return original_start(config, opts, ...)
  end
end)()

local augroup_lsp_config = vim.api.nvim_create_augroup("UserLspConfig", {})
local augroup_highlight = vim.api.nvim_create_augroup("UserLspHighlight", {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup_lsp_config,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client == nil then
      return
    end

    if client:supports_method "textDocument/documentHighlight" then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = augroup_highlight,
        buffer = ev.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "BufLeave" }, {
        group = augroup_highlight,
        buffer = ev.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = augroup_lsp_config,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end

    if client:supports_method "textDocument/documentHighlight" then
      vim.api.nvim_clear_autocmds { buffer = args.buf, group = augroup_highlight }
    end
  end,
})

vim.lsp.enable {
  "expert",
  "luals",
  "basedpyright",
  "ruff",
  "css",
  "html",
  "gopls",
  "golangci_lint",
  "tsls",
  "rust_analyzer",
  "ruby_lsp",
}
-- }}}
