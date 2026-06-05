local context = require "agent.context"
local notify = require "agent.notify"
local prompt_buffer = require "agent.prompt_buffer"

---@class AgentSendOpts
---@field focus? boolean
---@field compose? boolean

---@class AgentAdapterSendOpts
---@field focus? boolean

---@class AgentAdapter
---@field send fun(message: string, send_opts?: AgentAdapterSendOpts): any

---@class AgentConfig
---@field adapter AgentAdapter
---@field prompt_buffer? AgentPromptBufferOpts

---@class AgentInstance
---@field send fun(instruction_or_opts?: string|AgentSendOpts, send_opts?: AgentSendOpts): any
---@field send_selection fun(instruction_or_opts?: string|AgentSendOpts, send_opts?: AgentSendOpts): any

---@class AgentAdapterConstructors
---@field neovim fun(adapter_opts: AgentNeovimAdapterOpts): AgentAdapter
---@field kitty fun(adapter_opts: AgentKittyAdapterOpts): AgentAdapter

local M = {}

---@type AgentAdapterConstructors
M.adapter = {
  neovim = require("agent.adapters.neovim").new,
  kitty = require("agent.adapters.kitty").new,
}

---@param context_text string
---@param instruction? string
---@return string
local function with_instruction(context_text, instruction)
  context_text = context_text:gsub("\n*$", "")

  if not instruction or instruction == "" then
    return context_text .. "\n\n"
  end

  return context_text .. "\n\n" .. instruction
end

---@param instruction_or_opts? string|AgentSendOpts
---@param send_opts? AgentSendOpts
---@return string? instruction
---@return AgentSendOpts? send_opts
local function normalize_send_args(instruction_or_opts, send_opts)
  if type(instruction_or_opts) == "table" then
    return nil, instruction_or_opts
  end

  return instruction_or_opts, send_opts
end

---@param send_opts? AgentSendOpts
---@return AgentAdapterSendOpts
local function normalize_send_opts(send_opts)
  local result = vim.tbl_deep_extend("force", {}, send_opts or {})
  result.compose = nil
  return result
end

---@param agent_config AgentConfig
---@return AgentInstance
function M.new(agent_config)
  agent_config = agent_config or {}

  local adapter = agent_config.adapter
  if not adapter then
    error("Missing agent adapter")
  end

  local function send_payload(payload, send_opts)
    if send_opts and send_opts.compose then
      return prompt_buffer.open {
        message = payload,
        prompt_buffer = agent_config.prompt_buffer,
        on_submit = function(edited_payload)
          adapter.send(edited_payload, normalize_send_opts(send_opts))
        end,
      }
    end

    return adapter.send(payload, normalize_send_opts(send_opts))
  end

  return {
    send = function(instruction_or_opts, send_opts)
      local instruction, opts = normalize_send_args(instruction_or_opts, send_opts)
      return send_payload(with_instruction(context.current_file(), instruction), opts)
    end,
    send_selection = function(instruction_or_opts, send_opts)
      local instruction, opts = normalize_send_args(instruction_or_opts, send_opts)
      local context_text = context.selection()
      if context_text == "" then
        notify("No visual selection", vim.log.levels.WARN)
        return
      end

      return send_payload(with_instruction(context_text, instruction), opts)
    end,
  }
end

return M
