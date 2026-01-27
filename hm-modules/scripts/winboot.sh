#!/usr/bin/env bash

# Test mode: simulate multiple Windows entries
if [ "$1" = "--test" ]; then
  WIN_ENTRIES="
Boot0001* Windows Boot Manager
Boot0002  Windows 10
Boot0003  Windows 11"
  echo "Test mode: simulating multiple Windows entries"
else
  # Get all Windows boot entries (boot number and description)
  WIN_ENTRIES=$(efibootmgr | grep "Windows")
fi

# Check if any Windows boot loader was found
if [ -z "$WIN_ENTRIES" ]; then
  echo "Windows boot loader not found."
  exit 1
fi

# Count number of Windows entries
WIN_COUNT=$(echo "$WIN_ENTRIES" | wc -l)

if [ "$WIN_COUNT" -eq 1 ]; then
  # Only one entry, use it directly
  WIN_BOOT_NUM=$(echo "$WIN_ENTRIES" | awk '{print $1}' | sed 's/Boot//; s/\*//')
else
  # Multiple entries, let user select with gum
  SELECTED=$(echo "$WIN_ENTRIES" | gum choose --header "Select Windows boot entry:")

  if [ -z "$SELECTED" ]; then
    echo "No selection made."
    exit 1
  fi

  WIN_BOOT_NUM=$(echo "$SELECTED" | awk '{print $1}' | sed 's/Boot//; s/\*//')
fi

echo "Selected boot number: $WIN_BOOT_NUM"

# In test mode, don't actually reboot
if [ "$1" = "--test" ]; then
  echo "Test mode: would run 'sudo efibootmgr -n $WIN_BOOT_NUM' and reboot"
  exit 0
fi

# Set the next boot device to the Windows boot loader
sudo efibootmgr -n "$WIN_BOOT_NUM"
# Reboot the system
reboot
