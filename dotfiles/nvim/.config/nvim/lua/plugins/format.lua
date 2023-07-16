return {
  "elentok/format-on-save.nvim",
  dependencies = {
    -- both required for stylua custom handling
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = function(_, opts)
    local cached_stylua_configs = {}
    local find_stylua_config = function()
      local Path = require "plenary.path"
      local find_stylua_config_cached = function(path)
        if cached_stylua_configs[path] == nil then
          local file_path = Path:new(path)
          local lspconfig_util = require "lspconfig.util"
          local root_finder = lspconfig_util.root_pattern ".git"
          local root_path = Path:new(root_finder(path))

          local file_parents = file_path:parents()
          local root_parents = root_path:parents()

          local relative_diff = #file_parents - #root_parents
          for index, dir in ipairs(file_parents) do
            if index > relative_diff then
              break
            end

            local stylua_path = Path:new { dir, "stylua.toml" }
            if stylua_path:exists() then
              cached_stylua_configs[path] = stylua_path:absolute()
              break
            end

            stylua_path = Path:new { dir, ".stylua.toml" }
            if stylua_path:exists() then
              cached_stylua_configs[path] = stylua_path:absolute()
              break
            end
          end
        end

        return cached_stylua_configs[path]
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local filepath = Path:new(vim.api.nvim_buf_get_name(bufnr)):absolute()
      return find_stylua_config_cached(filepath)
    end

    local formatters = require "format-on-save.formatters"
    opts.formatter_by_ft = {
      go = formatters.lsp,
      lua = function()
        return formatters.shell {
          cmd = { "stylua", "--config-path", find_stylua_config(), "-" },
        }
      end,
    }
  end,
}
