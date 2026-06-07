#!/usr/bin/env bash
set -euo pipefail

INSTANCES=(
  "Script Anivia31"
)
TITLE_PATTERN="Taunahi"
LAUNCH_GAP=3

EXPECTED=${#INSTANCES[@]}
FOUND=0

echo "Launching ${EXPECTED} instance(s)..."

# snapshot existing matching windows
KNOWN=$(niri msg --json windows | jq -r --arg p "$TITLE_PATTERN" \
  '.[] | select(.title // "" | test($p)) | .id')

# launch all instances
for instance in "${INSTANCES[@]}"; do
  echo "Launching: $instance"
  prismlauncher -l "$instance" &>/dev/null &
  sleep "$LAUNCH_GAP"
done

echo "Waiting for $EXPECTED window(s)..."

# watch event stream, move each new matching window to the last workspace
niri msg -j event-stream |
  jq --unbuffered -r '.WindowOpenedOrChanged?.window | select(.) | "\(.id) \(.title // "")"' |
  while read -r id title; do
    echo "$title" | grep -qE "$TITLE_PATTERN" || continue
    echo "$KNOWN" | grep -qxF "$id" && continue
    KNOWN="$KNOWN
$id"

    LAST_WS=$(niri msg --json workspaces | jq -r 'max_by(.id) | .id')
    echo "Caught: $title (id=$id) → last workspace $LAST_WS"
    niri msg action move-window-to-workspace --window-id "$id" "$LAST_WS"
    niri msg action focus-workspace-previous

    FOUND=$((FOUND + 1))
    [ "$FOUND" -ge "$EXPECTED" ] && break
  done

echo "Done. Moved $FOUND window(s)."
