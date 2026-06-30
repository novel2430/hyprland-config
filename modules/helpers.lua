local basic = require("modules.basic")

local M = {}

function M.keybind_string(parts, opts)
  opts = opts or {}

  if opts.mainMod == nil then
    opts.mainMod = true
  end

  local keys = {}

  if opts.mainMod then
    table.insert(keys, basic.mainMod)
  end

  for _, key in ipairs(parts) do
    if key ~= nil and key ~= "" then
      table.insert(keys, tostring(key))
    end
  end

  return table.concat(keys, " + ")
end

function M.active_monitor_name()
  local monitor = hl.get_active_monitor()
  return monitor and monitor.name or nil
end

function M.local_workspace_name(monitor_name, num)
  return monitor_name .. ":" .. tostring(num)
end

function M.local_workspace_selector(monitor_name, num)
  return "name:" .. M.local_workspace_name(monitor_name, num)
end

function M.workspace_selector_from_workspace(ws)
  if not ws then
    return nil
  end

  -- For named workspaces, prefer name:<name>.
  -- Example: DP-1:1 -> name:DP-1:1
  if ws.name and ws.name ~= "" and ws.name ~= tostring(ws.id) then
    if ws.name:sub(1, 5) == "name:" then
      return ws.name
    end

    return "name:" .. ws.name
  end

  -- For normal numeric workspaces.
  if ws.id then
    return tostring(ws.id)
  end

  return nil
end

function M.current_workspace_layout(layout)
  local ws = hl.get_active_workspace()
  local workspace = M.workspace_selector_from_workspace(ws)

  if not workspace then
    return
  end

  hl.workspace_rule({
    workspace = workspace,
    layout = layout,
  })
end

function M.switch_local_workspace(num)
  return function()
    local monitor_name = M.active_monitor_name()

    if not monitor_name then
      return
    end

    hl.dispatch(hl.dsp.focus({
      workspace = M.local_workspace_selector(monitor_name, num),
      on_current_monitor = true,
    }))
  end
end

function M.move_window_to_local_workspace(num, follow)
  return function()
    local monitor_name = M.active_monitor_name()

    if not monitor_name then
      return
    end

    hl.dispatch(hl.dsp.window.move({
      workspace = M.local_workspace_selector(monitor_name, num),
      follow = follow == true,
    }))
  end
end

local function escape_lua_pattern(s)
  return tostring(s):gsub("([^%w])", "%%%1")
end

function M.local_workspace_index(monitor_name, ws)
  if not monitor_name or not ws or not ws.name then
    return nil
  end

  local name = ws.name

  -- Just in case some API returns name:DP-1:1 instead of DP-1:1
  name = name:gsub("^name:", "")

  local pattern = "^" .. escape_lua_pattern(monitor_name) .. ":(%d+)$"
  local index = name:match(pattern)

  return index and tonumber(index) or nil
end

function M.cycle_local_workspace(delta)
  return function()
    local monitor_name = M.active_monitor_name()

    if not monitor_name then
      return
    end

    local ws = hl.get_active_workspace()
    local current = M.local_workspace_index(monitor_name, ws)

    -- If current workspace is not one of this monitor's local workspaces,
    -- enter local workspace 1 first.
    if not current then
      current = 1 - delta
    end

    local count = basic.LOCAL_WS_COUNT
    local next_index = ((current - 1 + delta) % count) + 1

    hl.dispatch(hl.dsp.focus({
      workspace = M.local_workspace_selector(monitor_name, next_index),
      on_current_monitor = true,
    }))
  end
end

return M
