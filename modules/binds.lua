-- modules/binds.lua

local basic = require("modules.basic")
local helper = require("modules.helpers")

local bind = helper.keybind_string

local apps = {
  terminal = "alacritty",
  dlauncher = "rofi -show drun",
  rlauncher = "rofi -show run",
  browser = "firefox",
  lock = "my-swaylock idle",
  clipboard = "wlroot-clipboard",
  powermenu = "rofi-power-menu",
  volumeUp = "my-volume up",
  volumeDown = "my-volume down",
  volumeMute = "my-volume mute",
  brightnessUp = "brightnessctl set 10%+",
  brightnessDown = "brightnessctl set 10%-",
  screenshotFull = "grim-slurp-screenshot full",
  screenshotSelect = "grim-slurp-screenshot",
}

-- =====================
-- Apps / session
-- =====================

hl.bind(
  bind({ "Return" }),
  hl.dsp.exec_cmd(apps.terminal)
)
hl.bind(
  bind({ "D" }),
  hl.dsp.exec_cmd(apps.dlauncher)
)
hl.bind(
  bind({ "R" }),
  hl.dsp.exec_cmd(apps.rlauncher)
)
hl.bind(
  bind({ "SHIFT", "F" }),
  hl.dsp.exec_cmd(apps.browser)
)
hl.bind(
  bind({ "SHIFT", "L" }),
  hl.dsp.exec_cmd(apps.lock)
)
hl.bind(
  bind({ "C" }),
  hl.dsp.exec_cmd(apps.clipboard)
)
hl.bind(
  bind({ "SHIFT", "P" }),
  hl.dsp.exec_cmd(apps.powermenu)
)
hl.bind(
  bind({ "XF86AudioRaiseVolume" }, { mainMod = false }),
  hl.dsp.exec_cmd(apps.volumeUp)
)
hl.bind(
  bind({ "XF86AudioLowerVolume" }, { mainMod = false }),
  hl.dsp.exec_cmd(apps.volumeDown)
)
hl.bind(
  bind({ "XF86AudioMute" }, { mainMod = false }),
  hl.dsp.exec_cmd(apps.volumeMute)
)
hl.bind(
  bind({ "XF86MonBrightnessUp" }, { mainMod = false }),
  hl.dsp.exec_cmd(apps.brightnessUp)
)
hl.bind(
  bind({ "XF86MonBrightnessDown" }, { mainMod = false }),
  hl.dsp.exec_cmd(apps.brightnessDown)
)
hl.bind(
  bind({ "Print" }),
  hl.dsp.exec_cmd(apps.screenshotSelect)
)
hl.bind(
  bind({ "Print" }, { mainMod = false }),
  hl.dsp.exec_cmd(apps.screenshotFull)
)
hl.bind(
  bind({ "SHIFT", "E" }),
  hl.dsp.exec_cmd(basic.logout_cmd)
)

-- =====================
-- Window actions
-- =====================

hl.bind(
  bind({ "Q" }),
  hl.dsp.window.close()
)

hl.bind(
  bind({ "F" }),
  hl.dsp.window.fullscreen({
    mode = "fullscreen",
    action = "toggle",
  })
)

hl.bind(
  bind({ "SHIFT", "SPACE" }),
  hl.dsp.window.float({
    action = "toggle",
  })
)

-- Mouse move / resize
hl.bind(
  basic.mainMod .. " + mouse:272",
  hl.dsp.window.drag(),
  { mouse = true }
)

hl.bind(
  basic.mainMod .. " + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true }
)

-- =====================
-- Layout controls
-- =====================

hl.bind(
  bind({ "J" }),
  hl.dsp.layout("cyclenext")
)

hl.bind(
  bind({ "K" }),
  hl.dsp.layout("cycleprev")
)

hl.bind(
  bind({ "H" }),
  hl.dsp.layout("mfact -0.05")
)

hl.bind(
  bind({ "L" }),
  hl.dsp.layout("mfact +0.05")
)

hl.bind(
  bind({ "SHIFT", "Return" }),
  hl.dsp.layout("swapwithmaster")
)

hl.bind(
  bind({ "M" }),
  function()
    helper.current_workspace_layout("monocle")
  end
)

hl.bind(
  bind({ "E" }),
  function()
    helper.current_workspace_layout("master")
  end
)

-- =====================
-- Monitor focus
-- =====================

hl.bind(
  bind({ "O" }),
  hl.dsp.focus({
    monitor = "+1",
  })
)

-- =====================
-- Local workspaces
-- =====================

for i = 1, basic.LOCAL_WS_COUNT do
  -- mainMod + 1..9:
  -- switch to this monitor's local workspace
  hl.bind(
    bind({ i }),
    helper.switch_local_workspace(i)
  )

  -- mainMod + Shift + 1..9:
  -- move active window to this monitor's local workspace
  hl.bind(
    bind({ "SHIFT", i }),
    helper.move_window_to_local_workspace(i, false)
  )
end

-- =====================
-- Cycle local workspaces
-- =====================

hl.bind(
  bind({ "CTRL", "J" }),
  helper.cycle_local_workspace(1)
)

hl.bind(
  bind({ "CTRL", "K" }),
  helper.cycle_local_workspace(-1)
)
