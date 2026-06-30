#!/bin/sh

dbus-update-activation-environment \
  WAYLAND_DISPLAY \
  XDG_CURRENT_DESKTOP \
  XDG_SESSION_DESKTOP \
  XDG_SESSION_TYPE \
  DISPLAY \
  XAUTHORITY \
  DBUS_SESSION_BUS_ADDRESS

if ! pgrep -x pipewire >/dev/null 2>&1; then
  /usr/bin/pipewire &
fi

if ! pgrep -x wireplumber >/dev/null 2>&1; then
  /usr/bin/wireplumber &
fi

if ! pgrep -x pipewire-pulse >/dev/null 2>&1; then
  /usr/bin/pipewire-pulse &
fi
