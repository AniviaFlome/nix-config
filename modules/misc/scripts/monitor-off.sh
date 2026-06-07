#!/usr/bin/env dash

# Convert desktop name to lowercase for simple matching
# shellcheck disable=SC2039
if [ -z "$XDG_CURRENT_DESKTOP" ]; then
  exit 0
fi

DESKTOP=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

case "$DESKTOP" in
*niri*)
  niri msg action power-off-monitors
  ;;
*hyprland*)
  hyprctl dispatch dpms off
  ;;
*kde* | *plasma*)
  qdbus6 org.kde.KWin /KWin toggleScreenOff
  ;;
esac
