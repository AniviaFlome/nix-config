#!/usr/bin/env bash
# Dependencies: gum, speaker-test

set -euo pipefail

# Colors
ACCENT="212"
SUCCESS="120"
WARNING="214"
INFO="75"

# Default values
DURATION=1
FREQUENCY=440

# Use alternate screen buffer (like vim/less)
tput smcup
trap 'tput rmcup' EXIT

# Check for dependencies
check_deps() {
  local missing=()
  for cmd in gum speaker-test; do
    if ! command -v "$cmd" &>/dev/null; then
      missing+=("$cmd")
    fi
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    echo "Missing dependencies: ${missing[*]}"
    echo "Please install 'gum' and 'alsa-utils'."
    exit 1
  fi
}

# Styled header
show_header() {
  gum style \
    --border double \
    --margin "1" \
    --padding "1 3" \
    --border-foreground "$ACCENT" \
    --foreground "$ACCENT" \
    --bold \
    "Audio Channel Tester"
}

# Show current settings
show_settings() {
  gum style \
    --foreground "$INFO" \
    --italic \
    "Duration: ${DURATION}s | Frequency: ${FREQUENCY}Hz"
}

# Progress indicator during test
show_progress() {
  local msg=$1
  local dur=$2
  gum spin --spinner dot --title "$msg" -- sleep "$dur"
}

# Test functions
test_left() {
  gum style --foreground "$SUCCESS" --bold "Testing LEFT Channel..."
  (timeout "${DURATION}s" speaker-test -t sine -f "$FREQUENCY" -c 2 -s 1 &>/dev/null) &
  show_progress "Playing on LEFT speaker" "$DURATION"
  wait 2>/dev/null || true
}

test_right() {
  gum style --foreground "$SUCCESS" --bold "Testing RIGHT Channel..."
  (timeout "${DURATION}s" speaker-test -t sine -f "$FREQUENCY" -c 2 -s 2 &>/dev/null) &
  show_progress "Playing on RIGHT speaker" "$DURATION"
  wait 2>/dev/null || true
}

test_both() {
  gum style --foreground "$SUCCESS" --bold "Testing BOTH Channels..."
  # Run left and right simultaneously
  (timeout "${DURATION}s" speaker-test -t sine -f "$FREQUENCY" -c 2 -s 1 &>/dev/null) &
  (timeout "${DURATION}s" speaker-test -t sine -f "$FREQUENCY" -c 2 -s 2 &>/dev/null) &
  show_progress "Playing on BOTH speakers" "$DURATION"
  wait 2>/dev/null || true
}

test_frequency_sweep() {
  gum style --foreground "$SUCCESS" --bold "Frequency Sweep (20Hz to 20kHz)..."
  (timeout "${DURATION}s" speaker-test -t sine -f 20 -F 20000 -c 2 &>/dev/null 2>&1) &
  show_progress "Sweeping frequencies" "$DURATION"
  wait 2>/dev/null || true
}

test_bass() {
  gum style --foreground "$SUCCESS" --bold "Bass Test (60Hz)..."
  (timeout "${DURATION}s" speaker-test -t sine -f 60 -c 2 &>/dev/null) &
  show_progress "Playing bass frequency" "$DURATION"
  wait 2>/dev/null || true
}

test_mid() {
  gum style --foreground "$SUCCESS" --bold "Mid-Range Test (1kHz)..."
  (timeout "${DURATION}s" speaker-test -t sine -f 1000 -c 2 &>/dev/null) &
  show_progress "Playing mid frequency" "$DURATION"
  wait 2>/dev/null || true
}

test_treble() {
  gum style --foreground "$SUCCESS" --bold "Treble Test (8kHz)..."
  (timeout "${DURATION}s" speaker-test -t sine -f 8000 -c 2 &>/dev/null) &
  show_progress "Playing treble frequency" "$DURATION"
  wait 2>/dev/null || true
}

# Settings menu
settings_menu() {
  while true; do
    clear
    show_header
    gum style --foreground "$WARNING" --bold "Settings"

    local choice
    choice=$(gum choose \
      --cursor.foreground "$ACCENT" \
      --header "Adjust test parameters:" \
      "Duration: ${DURATION}s" \
      "Frequency: ${FREQUENCY}Hz" \
      "Back to Main Menu")

    case $choice in
    "Duration: ${DURATION}s")
      DURATION=$(gum input \
        --placeholder "Enter duration (1-10 seconds)" \
        --value "$DURATION" \
        --char-limit 2 | grep -E '^[0-9]+$' || echo "$DURATION")
      [[ $DURATION -lt 1 ]] && DURATION=1
      [[ $DURATION -gt 10 ]] && DURATION=10
      ;;
    "Frequency: ${FREQUENCY}Hz")
      FREQUENCY=$(gum input \
        --placeholder "Enter frequency (20-20000 Hz)" \
        --value "$FREQUENCY" \
        --char-limit 5 | grep -E '^[0-9]+$' || echo "$FREQUENCY")
      [[ $FREQUENCY -lt 20 ]] && FREQUENCY=20
      [[ $FREQUENCY -gt 20000 ]] && FREQUENCY=20000
      ;;
    "Back to Main Menu")
      break
      ;;
    esac
  done
}

# Channel tests submenu
channel_menu() {
  while true; do
    clear
    show_header
    show_settings
    gum style --foreground "$INFO" --bold "Channel Tests"

    local choice
    choice=$(gum choose \
      --cursor.foreground "$ACCENT" \
      --header "Select channel test:" \
      "Left Channel" \
      "Right Channel" \
      "Both Channels" \
      "Back")

    case $choice in
    "Left Channel") test_left ;;
    "Right Channel") test_right ;;
    "Both Channels") test_both ;;
    "Back") break ;;
    esac

    gum style --foreground "$SUCCESS" "Test complete!"
    sleep 0.5
  done
}

# Frequency tests submenu
frequency_menu() {
  while true; do
    clear
    show_header
    show_settings
    gum style --foreground "$INFO" --bold "Frequency Tests"

    local choice
    choice=$(gum choose \
      --cursor.foreground "$ACCENT" \
      --header "Select frequency test:" \
      "Bass (60Hz)" \
      "Mid-Range (1kHz)" \
      "Treble (8kHz)" \
      "Custom Frequency (${FREQUENCY}Hz)" \
      "Frequency Sweep (20Hz to 20kHz)" \
      "Back")

    case $choice in
    "Bass (60Hz)") test_bass ;;
    "Mid-Range (1kHz)") test_mid ;;
    "Treble (8kHz)") test_treble ;;
    "Custom Frequency (${FREQUENCY}Hz)")
      gum style --foreground "$SUCCESS" --bold "Custom Frequency (${FREQUENCY}Hz)..."
      (timeout "${DURATION}s" speaker-test -t sine -f "$FREQUENCY" -c 2 &>/dev/null) &
      show_progress "Playing ${FREQUENCY}Hz" "$DURATION"
      wait 2>/dev/null || true
      ;;
    "Frequency Sweep (20Hz to 20kHz)") test_frequency_sweep ;;
    "Back") break ;;
    esac

    gum style --foreground "$SUCCESS" "Test complete!"
    sleep 0.5
  done
}

# Quick test - left, right, both only
quick_test() {
  clear
  show_header
  gum style --foreground "$WARNING" --bold "Running Quick Test..."
  echo

  gum style --foreground "$INFO" "[1/3] Left Channel"
  test_left

  gum style --foreground "$INFO" "[2/3] Right Channel"
  test_right

  gum style --foreground "$INFO" "[3/3] Both Channels"
  test_both

  echo
  gum style --foreground "$SUCCESS" --bold "Quick test complete!"
  gum input --placeholder "Press Enter to continue..."
}

# Main menu
main_menu() {
  check_deps

  while true; do
    clear
    show_header
    show_settings

    local choice
    choice=$(gum choose \
      --cursor.foreground "$ACCENT" \
      --header "Select test category:" \
      "Quick Test (L/R/Both)" \
      "Channel Tests" \
      "Frequency Tests" \
      "Settings" \
      "Quit")

    case $choice in
    "Quick Test (L/R/Both)") quick_test ;;
    "Channel Tests") channel_menu ;;
    "Frequency Tests") frequency_menu ;;
    "Settings") settings_menu ;;
    "Quit")
      exit 0
      ;;
    esac
  done
}

# Run
main_menu
