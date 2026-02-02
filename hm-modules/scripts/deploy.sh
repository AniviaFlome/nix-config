#!/usr/bin/env bash
set -euo pipefail

# Deploy nix-config to remote host and rebuild

usage() {
  echo "Usage: $(basename "$0") USER HOST PATH HOSTNAME [PORT]"
  echo ""
  echo "Sync nix-config to remote host and rebuild NixOS"
  echo ""
  echo "Arguments:"
  echo "  USER      SSH username"
  echo "  HOST      Remote host address"
  echo "  PATH      Remote path for nix-config"
  echo "  HOSTNAME  NixOS configuration name from flake"
  echo "  PORT      SSH port (default: 22)"
  exit 1
}

if [[ $# -lt 4 || $# -gt 5 ]]; then
  usage
fi

USER="$1"
HOST="$2"
RPATH="$3"
HOSTNAME="$4"
PORT="${5:-22}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIX_CONFIG_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Syncing nix-config to $USER@$HOST:$RPATH/nix-config (port $PORT)..."
rsync -av --filter=':- .gitignore' -e "ssh -l $USER -oport=$PORT" "$NIX_CONFIG_DIR/" "$USER@$HOST:$RPATH/nix-config"

echo "Rebuilding NixOS on $HOST with configuration $HOSTNAME..."
ssh -l "$USER" -p "$PORT" "$HOST" "cd $RPATH/nix-config && sudo nixos-rebuild switch --flake .#$HOSTNAME"

echo "Deploy complete!"
