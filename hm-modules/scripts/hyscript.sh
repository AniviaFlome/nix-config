#!/usr/bin/env dash

set -eu

INSTANCES="
Script 31avcisi
Script Anivia31
Script sikisci31
"
INSTANCE_COUNT=3
TARGET_WORKSPACE=9
LAUNCH_GAP=3
POLL_INTERVAL=0.5

detect_compositor() {
  if [ -n "${NIRI_SOCKET:-}" ] || pgrep -x niri >/dev/null 2>&1; then
    echo "niri"
  elif [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ] || pgrep -x Hyprland >/dev/null 2>&1; then
    echo "hyprland"
  elif echo "${XDG_CURRENT_DESKTOP:-}" | grep -q "KDE" || pgrep -x kwin_wayland >/dev/null 2>&1; then
    echo "kde"
  else
    echo "unknown"
  fi
}

# Get only Minecraft window IDs (filters by title starting with "Minecraft",
# since Java/GLFW windows often report null app_id)
get_minecraft_windows() {
  case "$COMPOSITOR" in
  niri)
    niri msg --json windows 2>/dev/null | jq -r '.[] | select(.title // "" | test("^Minecraft")) | .id' 2>/dev/null || true
    ;;
  hyprland)
    hyprctl clients -j 2>/dev/null | jq -r '.[] | select(.title // "" | test("^Minecraft")) | .address' 2>/dev/null || true
    ;;
  kde)
    kdotool search --name "Minecraft*" 2>/dev/null || true
    ;;
  esac
}

move_to_workspace() {
  _wid="$1"
  _target="$2"
  case "$COMPOSITOR" in
  niri)
    niri msg action move-window-to-workspace --window-id "$_wid" --focus false "$_target" 2>/dev/null || true
    ;;
  hyprland)
    hyprctl dispatch movetoworkspacesilent "$_target,address:$_wid" 2>/dev/null || true
    ;;
  kde)
    kdotool windowsetdesktop "$_wid" "$_target" 2>/dev/null || true
    ;;
  esac
}

id_in_list() {
  case "
$2
" in
  *"
$1
"*) return 0 ;;
  *) return 1 ;;
  esac
}

wait_for_minecraft_windows() {
  _count="$1"
  _known="$2"
  _new=""
  _new_count=0

  while [ "$_new_count" -lt "$_count" ]; do
    # Only get Minecraft windows, not PrismLauncher or anything else
    _current=$(get_minecraft_windows)

    for _wid in $_current; do
      [ -z "$_wid" ] && continue

      # Skip if already known or already found
      if id_in_list "$_wid" "$_known" 2>/dev/null || id_in_list "$_wid" "$_new" 2>/dev/null; then
        continue
      fi

      # New Minecraft window found
      if [ -n "$_new" ]; then
        _new="$_new
$_wid"
      else
        _new="$_wid"
      fi
      _new_count=$((_new_count + 1))

      # Move every window directly to the target workspace
      move_to_workspace "$_wid" "$TARGET_WORKSPACE"
    done

    sleep "$POLL_INTERVAL"
  done
}

COMPOSITOR=""

main() {
  COMPOSITOR=$(detect_compositor)
  [ "$COMPOSITOR" = "unknown" ] && exit 1

  known_mc_windows=$(get_minecraft_windows)

  # Launch all instances
  IFS='
'
  for instance in $INSTANCES; do
    prismlauncher -l "$instance" >/dev/null 2>&1 &
    sleep "$LAUNCH_GAP"
  done
  unset IFS

  # Wait for Minecraft windows only, move each as it appears
  wait_for_minecraft_windows "$INSTANCE_COUNT" "$known_mc_windows"
}

main "$@"
