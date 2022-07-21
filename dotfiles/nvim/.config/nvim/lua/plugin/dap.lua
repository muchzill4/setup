local dap = prequire "dap"

if not dap then
  return nil
end

local dap_go = prequire "dap-go"
if dap_go then
  dap_go.setup()
end
