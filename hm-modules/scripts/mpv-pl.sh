#!/usr/bin/env bash
# Play all videos in a directory with mpv in sorted numeric order

set -euo pipefail

VIDEO_EXTENSIONS="mp4|mkv|avi|webm|mov|flv|wmv|m4v|mpg|mpeg|3gp|ts"
SEARCH_DIR="${1:-.}"

# Find all video files and sort them naturally (1, 2, 3... not 1, 10, 2)
mapfile -t videos < <(find "$SEARCH_DIR" -type f -regextype posix-extended \
    -regex ".*\.($VIDEO_EXTENSIONS)$" 2>/dev/null | sort -V)

# Check if any videos were found
if [[ ${#videos[@]} -eq 0 ]]; then
    echo "No videos found in: $SEARCH_DIR"
    exit 1
fi

echo "Playing ${#videos[@]} videos in order:"
for i in "${!videos[@]}"; do
    echo "  $((i+1)). $(basename "${videos[$i]}")"
done

# Launch mpv with all videos as playlist
exec mpv "${videos[@]}"
