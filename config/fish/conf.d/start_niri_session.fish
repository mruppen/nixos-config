if [ -z "$WAYLAND_SESSION" ] & [ "$XDG_SESSION_TYPE" != "wayland" ]; then
  niri-session
fi
