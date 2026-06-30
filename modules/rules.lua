-- modules/rules.lua

local basic = require("modules.basic")
local helper = require("modules.helpers")
local monitors = require("modules.monitors")

-- =====================
-- Window rules
-- =====================

hl.window_rule({
  name = "suppress-maximize-events",
  match = {
    class = ".*",
  },
  suppress_event = "maximize",
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class      = "^$",
    title      = "^$",
    xwayland   = true,
    float      = true,
    fullscreen = false,
    pin        = false,
  },
  no_focus = true,
})

hl.window_rule({
  name  = "move-hyprland-run",
  match = {
    class = "hyprland-run",
  },
  move  = "20 monitor_h-120",
  float = true,
})

-- =====================
-- Local workspace rules
-- =====================

local registered_monitors = {}

local function monitor_name_from(mon)
  if type(mon) == "string" then
    return mon
  end

  if type(mon) == "table" then
    return mon.name or mon.output
  end

  return nil
end

local function register_local_workspaces_for_monitor(mon)
  local monitor_name = monitor_name_from(mon)

  if not monitor_name or monitor_name == "" then
    return
  end

  if registered_monitors[monitor_name] then
    return
  end

  registered_monitors[monitor_name] = true

  for i = 1, basic.LOCAL_WS_COUNT do
    hl.workspace_rule({
      workspace  = helper.local_workspace_selector(monitor_name, i),
      monitor    = monitor_name,
      persistent = true,
      default    = i == 1,
    })
  end
end

-- 1. Static monitors declared in modules.monitors.
-- This is the startup-stable path.
for _, mon in ipairs(monitors.list) do
  register_local_workspaces_for_monitor(mon)
end

-- 2. Monitors that are already present but not in monitors.list.
-- Useful if you also use a fallback monitor rule.
local runtime_monitors = hl.get_monitors()
if runtime_monitors then
  for _, mon in ipairs(runtime_monitors) do
    register_local_workspaces_for_monitor(mon)
  end
end

-- 3. Hotplug monitors.
-- Do not dispatch/focus here. Just create rules.
hl.on("monitor.added", function(mon)
  register_local_workspaces_for_monitor(mon)
end)

-- 4. Layout changed can happen on add/remove/reload/resolution changes.
-- Re-scan current monitors, but still only create missing rules.
hl.on("monitor.layout_changed", function()
  local current_monitors = hl.get_monitors()

  if not current_monitors then
    return
  end

  for _, mon in ipairs(current_monitors) do
    register_local_workspaces_for_monitor(mon)
  end
end)
