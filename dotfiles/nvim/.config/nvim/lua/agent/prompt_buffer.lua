---@class AgentPromptBufferOpts
---@field split? string

---@class AgentPromptBufferConfig
---@field split string

local M = {}

local defaults = {
  split = "botright split",
}

local sequence = 0

local function trim_trailing_blank_lines(lines)
  local last = #lines
  while last > 0 and lines[last] == "" do
    last = last - 1
  end
  return vim.list_slice(lines, 1, last)
end

local function message_from_buffer(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  lines = trim_trailing_blank_lines(lines)
  return table.concat(lines, "\n")
end

local function buffer_name()
  sequence = sequence + 1
  return string.format("agent-prompt://%d", sequence)
end

local function initial_lines(message)
  if not message or message == "" then
    return { "" }
  end
  return vim.split(message, "\n", { plain = true })
end

---@param prompt_buffer_opts? AgentPromptBufferOpts
---@return AgentPromptBufferConfig
local function normalize_prompt_buffer_config(prompt_buffer_opts)
  return vim.tbl_deep_extend("force", {}, defaults, prompt_buffer_opts or {})
end

---@class AgentPromptBufferOpenArgs
---@field message string
---@field prompt_buffer? AgentPromptBufferOpts
---@field on_submit fun(message: string)

---@param args AgentPromptBufferOpenArgs
---@return integer bufnr
function M.open(args)
  args = args or {}
  if args.message == nil then
    error("Missing prompt buffer message")
  end
  if not args.on_submit then
    error("Missing prompt buffer on_submit callback")
  end

  local prompt_buffer_config = normalize_prompt_buffer_config(args.prompt_buffer)

  vim.cmd(prompt_buffer_config.split)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, bufnr)

  vim.api.nvim_buf_set_name(bufnr, buffer_name())
  vim.bo[bufnr].buftype = "acwrite"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].filetype = "markdown"
  vim.bo[bufnr].swapfile = false

  local lines = initial_lines(args.message)
  local last_line = lines[#lines] or ""
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { #lines, #last_line })
  vim.cmd "startinsert"

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = bufnr,
    callback = function()
      args.on_submit(message_from_buffer(bufnr))
      vim.bo[bufnr].modified = false

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_delete(bufnr, { force = true })
        end
      end)
    end,
  })

  return bufnr
end

return M
