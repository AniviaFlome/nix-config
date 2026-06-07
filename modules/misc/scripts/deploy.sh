#!/usr/bin/env dash
set -eu

# Deploy nix-config to remote host and rebuild

usage() {
  echo "Usage: $(basename "$0") LOCAL_PATH USER HOST REMOTE_PATH HOSTNAME [PORT] [FOLDER_NAME]"
  echo ""
  echo "Sync nix-config to remote host and rebuild NixOS"
  echo ""
  echo "Arguments:"
  echo "  LOCAL_PATH  Local path to nix-config directory"
  echo "  USER        SSH username"
  echo "  HOST        Remote host address"
  echo "  REMOTE_PATH Remote path for nix-config"
  echo "  HOSTNAME    NixOS configuration name from flake"
  echo "  PORT        SSH port (default: 22)"
  echo "  FOLDER_NAME Remote folder name (default: nix-config)"
  exit 1
}

if [ $# -lt 5 ] || [ $# -gt 7 ]; then
  usage
fi

LOCAL_PATH="$1"
USER="$2"
HOST="$3"
RPATH="$4"
HOSTNAME="$5"
PORT="${6:-22}"
FOLDER_NAME="${7:-nix-config}"

echo "Syncing $FOLDER_NAME to $USER@$HOST:$RPATH/$FOLDER_NAME (port $PORT)..."
rsync -av --filter=':- .gitignore' -e "ssh -l $USER -oport=$PORT" "$LOCAL_PATH/" "$USER@$HOST:$RPATH/$FOLDER_NAME"

echo "Rebuilding NixOS on $HOST with configuration $HOSTNAME..."
ssh -l "$USER" -p "$PORT" "$HOST" "cd $RPATH/$FOLDER_NAME && sudo nixos-rebuild switch --flake .#$HOSTNAME"

echo "Deploy complete!"
