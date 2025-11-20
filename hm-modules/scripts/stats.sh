#!/usr/bin/env bash
# basic stats checker script mostly adapted from statusbar, may need changes to work on your system
CPU_TEMP=$(
  sensors | awk '
    /^Tctl:/ || /^Tdie:/ || /^Package id 0:/ || /^Core 0:/ || /^CPU:/ || /^temp1:/ {
        gsub(/[+°C]/, "");
        for (i = 1; i <= NF; i++) {
            if ($i ~ /^[0-9]+(\.[0-9]+)?$/) {
                gsub(/\..*/, "", $i);  # strip decimal
                print $i;
                exit;
            }
        }
    }'
)

GPU_TEMP=$(sensors | awk '/^edge/ {print substr($2,2)}')
if [[ -z $GPU_TEMP ]]; then
  if command -v nvidia-smi &>/dev/null; then
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
  fi
fi

MEM_USE=$(free -m | awk '/^Mem/ {print ($3)/1024}' | cut -c-4)
CPU_USE=$(iostat -c | awk 'NR>=4 && NR <=4' | awk '{print "User CPU: "$1"%\nSystem CPU: ",$3"%"}')
FAN_SPEED=$(sensors | awk '/^fan/ {print $2" "$3}')

DISK1=$(df -h ~/ | awk 'NR==2 {print $4}')
DISK2=$(df -h / | awk 'NR==2 {print $4}')

[[ -n $(amixer get Capture | awk '/\[on\]/') ]] && MIC="on" || MIC="off"

UPDATE=$(stat -c %y /nix/var/nix/profiles/system | awk '{print $1}')
KERNEL=$(uname -r)

echo -e "Stats $CPU_USE

GPU temp: $GPU_TEMP
CPU temp: $CPU_TEMP°C

Memory use: ${MEM_USE}g

Fan Speed: $FAN_SPEED

Home remaining: $DISK1
Root remaining: $DISK2

Last update: $UPDATE
Kernel Version: $KERNEL

Mic is $MIC" |
  bat -l cpuinfo --style=grid
