#!/usr/bin/env dash
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
