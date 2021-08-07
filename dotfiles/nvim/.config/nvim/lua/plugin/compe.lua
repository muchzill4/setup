local ok, compe = pcall(require, 'compe')

if not ok then return nil end

compe.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true
  }
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

_G.tab_complete = function()
  if vim.fn.call("vsnip#jumpable", {1}) == 1 then
    return t "<Plug>(vsnip-jump-next)"
  elseif vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t "<Plug>(vsnip-jump-prev)"
  elseif vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

local map = require("mc4.shortcuts").map

map("i", "<CR>", [[compe#confirm("<CR>")]], {expr = true, noremap = false})
map("i", "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = false})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true, noremap = false})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = false})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true, noremap = false})
