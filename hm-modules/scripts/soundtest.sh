#!/usr/bin/env bash
# Check for dependencies
for cmd in gum speaker-test timeout aplay head; do
  if ! command -v $cmd &>/dev/null; then
    echo "Error: $cmd is required but not installed."
    echo "Please install 'gum' (https://github.com/charmbracelet/gum) and 'alsa-utils'."
    exit 1
  fi
done

test_left() {
  gum style --foreground 212 "🔊 Testing LEFT Channel (Tone) for 1s..."
  timeout 1s speaker-test -t sine -f 440 -c 2 -s 1 >/dev/null 2>&1
}

test_right() {
  gum style --foreground 212 "🔊 Testing RIGHT Channel (Tone) for 1s..."
  timeout 1s speaker-test -t sine -f 440 -c 2 -s 2 >/dev/null 2>&1
}

test_both() {
  gum style --foreground 212 "🔊 Testing BOTH Channels (White Noise) for 1s..."
  head -c 176400 /dev/urandom | aplay -f cd >/dev/null 2>&1
}

# Main Loop
while true; do
  clear
  # Display Title
  gum style \
    --border normal \
    --margin "1" \
    --padding "1 2" \
    --border-foreground 212 \
    "🎧 Audio Channel Tester"

  # Display Menu
  CHOICE=$(gum choose \
    --cursor.foreground 212 \
    --header "Select a channel to test:" \
    "Left Only" \
    "Right Only" \
    "Both (Simultaneous)" \
    "Quit")

  # Handle Selection
  case $CHOICE in
  "Left Only")
    test_left
    ;;
  "Right Only")
    test_right
    ;;
  "Both (Simultaneous)")
    test_both
    ;;
  "Quit")
    exit 0
    ;;
  esac
done
