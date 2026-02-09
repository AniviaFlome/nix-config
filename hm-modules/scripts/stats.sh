#!/usr/bin/env dash
# basic stats checker script mostly adapted from statusbar, may need changes to work on your system
CPU_TEMP=$(
  sensors | awk '
    /Package id 0:/ { temp=$4; goto_clean=1 }
    /Tctl:/         { temp=$2; goto_clean=1 }
    goto_clean {
        gsub(/[+°C]/, "", temp);
        gsub(/\..*/, "", temp); # strip decimal
        print temp;
        exit;
    }
  '
)

GPU_TEMP=$(sensors | awk '/^edge/ {print substr($2,2)}')
if [ -z "$GPU_TEMP" ]; then
  if command -v nvidia-smi >/dev/null 2>&1; then
    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
  fi
fi

MEM_USE=$(free -m | awk '/^Mem/ {print ($3)/1024}' | cut -c-4)
CPU_USE=$(iostat -c | awk 'NR>=4 && NR <=4' | awk '{print "User CPU: "$1"%\nSystem CPU: ",$3"%"}')
FAN_SPEED=$(sensors | awk '/^fan/ {print $2" "$3}')

DISK1=$(df -h ~/ | awk 'NR==2 {print $4}')
DISK2=$(df -h / | awk 'NR==2 {print $4}')

# shellcheck disable=SC2046
if [ -n "$(amixer get Capture | awk '/\[on\]/')" ]; then MIC="on"; else MIC="off"; fi

UPDATE=$(stat -c %y /nix/var/nix/profiles/system | awk '{print $1}')
KERNEL=$(uname -r)

printf "Stats %s

GPU temp: %s
CPU temp: %s°C

Memory use: %sg

Fan Speed: %s

Home remaining: %s
Root remaining: %s

Last update: %s
Kernel Version: %s

Mic is %s\n" "$CPU_USE" "$GPU_TEMP" "$CPU_TEMP" "$MEM_USE" "$FAN_SPEED" "$DISK1" "$DISK2" "$UPDATE" "$KERNEL" "$MIC" |
  bat -l cpuinfo --style=grid
