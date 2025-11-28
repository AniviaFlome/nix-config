#!/usr/bin/env bash

# Convert desktop name to lowercase for simple matching
DESKTOP=${XDG_CURRENT_DESKTOP,,}

if [[ $DESKTOP == *"niri"* ]]; then
  niri msg action power-off-monitors
elif [[ $DESKTOP == *"hyprland"* ]]; then
  hyprctl dispatch dpms off
elif [[ $DESKTOP == *"kde"* ]] || [[ $DESKTOP == *"plasma"* ]]; then
  qdbus6 org.kde.KWin /KWin toggleScreenOff
fi
