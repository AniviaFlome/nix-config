#!/usr/bin/env dash
# Play all videos in a directory with mpv in sorted numeric order

set -eu

VIDEO_EXTENSIONS="mp4|mkv|avi|webm|mov|flv|wmv|m4v|mpg|mpeg|3gp|ts"
SEARCH_DIR="${1:-.}"

# Create a temp file for the playlist
PLAYLIST=$(mktemp)
# shellcheck disable=SC2064
trap 'rm -f "$PLAYLIST"' EXIT

# Find all video files and sort them naturally
# We assume GNU find/sort for -regextype and -V, which is standard in NixOS
find "$SEARCH_DIR" -type f -regextype posix-extended \
    -regex ".*\.($VIDEO_EXTENSIONS)$" 2>/dev/null | sort -V > "$PLAYLIST"

if [ ! -s "$PLAYLIST" ]; then
    echo "No videos found in: $SEARCH_DIR"
    exit 1
fi

COUNT=$(wc -l < "$PLAYLIST")
echo "Playing $COUNT videos in order:"
awk '{print NR". "$0}' "$PLAYLIST"

# Launch mpv with the playlist
exec mpv --playlist="$PLAYLIST"
