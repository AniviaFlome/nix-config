#!/usr/bin/env dash

notification=false

case "$1" in
-n | --notification) notification=true ;;
esac

# Get current profile
current=$(powerprofilesctl get)

# Cycle: power-saver -> balanced -> performance -> power-saver
case "$current" in
power-saver) next="balanced" ;;
balanced) next="performance" ;;
performance) next="power-saver" ;;
*) next="balanced" ;;
esac

# Apply it
powerprofilesctl set "$next"
echo "Power Profile Switched to: $next"

if "$notification"; then
  notify-send "Power Profile Switched" "$next"
fi
