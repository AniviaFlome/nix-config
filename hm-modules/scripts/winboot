#!/usr/bin/env bash

WIN_BOOT_NUM=$(efibootmgr | grep "Windows" | awk '{print $1}' | sed 's/Boot//; s/\*//')

# Check if the Windows boot loader was found
if [ -n "$WIN_BOOT_NUM" ]; then
  # Set the next boot device to the Windows boot loader
  sudo efibootmgr -n $WIN_BOOT_NUM
  # Reboot the system
  reboot
else
  echo "Windows boot loader not found."
  exit 1
fi
