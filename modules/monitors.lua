-- modules/monitors.lua

-- modules/monitors.lua

local M = {}

M.list = {
  {
    output    = "DP-3",
    mode      = "1920x1080@60",
    position  = "0x0",
    scale     = "auto",
    transform = 1,
  },
  {
    output   = "DP-1",
    mode     = "1920x1080@60",
    position = "1080x0",
    scale    = "auto",
  },
  {
    output   = "LVDS-1",
    mode     = "1366x768@60",
    position = "0x0",
    scale    = "auto",
  },
}

for _, monitor in ipairs(M.list) do
  hl.monitor(monitor)
end

-- Fallback for newly plugged / unknown monitors.
hl.monitor({
  output   = "",
  mode     = "preferred",
  position = "auto",
  scale    = 1,
})

return M
