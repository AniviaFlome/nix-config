#!/usr/bin/env bash
# Get current profile
current=$(powerprofilesctl get)

# Ordered cycle list
profiles=("power-saver" "balanced" "performance")

index=0

# Find index of current
for i in "${!profiles[@]}"; do
  if [[ ${profiles[$i]} == "$current" ]]; then
    index=$i
    break
  fi
done

# Calculate next index (wrap around)
next_index=$(((index + 1) % ${#profiles[@]}))

next="${profiles[$next_index]}"

# Apply it
powerprofilesctl set "$next"
echo Power Profile Switched to: $next
