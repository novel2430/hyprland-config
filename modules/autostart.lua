-- modules/autostart.lua

local M = {}

local gsettings_cli = [[
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' ;
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' ;
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' ;
gsettings set org.gnome.desktop.interface icon-theme 'Papirus' ;
]]

local once = {
  "$HOME/.config/hypr/scripts/session-bootstrap.sh",
  "start-wm $WAYLAND_DISPLAY",
  "swaybg -i $HOME/.local/share/pics/wallpaper -m fill",
  "dunst",
  "waybar -c $HOME/.config/hypr/waybar/waybar.jsonc -s $HOME/.config/hypr/waybar/waybar.css",
  "wl-paste --watch cliphist store",
  gsettings_cli,
  "fcitx5 --replace -d",
  "nm-applet",
  "flatpak override --user --env=LD_PRELOAD=/app/lib/wemeet/libhook.so com.tencent.wemeet",
  "kill -TERM $(pgrep -f idle-lock-guard) 2>/dev/null",
  "$HOME/.local/bin/idle-lock-guard > $HOME/.log/idle-lock-guard/idle-lock-guard.log 2>&1",
}

hl.on("hyprland.start", function()
  for _, cmd in ipairs(once) do
    hl.exec_cmd(cmd)
  end
end)

return M
