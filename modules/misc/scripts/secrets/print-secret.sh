#!/usr/bin/env dash
# Print a secret from sops file
# Usage: print-secret <secret_name> [sops_file]

set -eu

KEY_NAME="${1:-}"
SOPS_FILE="${2:-}"

if [ -z "$KEY_NAME" ]; then
  echo "Usage: $(basename "$0") <secret_name> [sops_file]"
  exit 1
fi

if [ -z "$SOPS_FILE" ]; then
  if [ -f "secrets/secrets.yaml" ]; then
    SOPS_FILE="secrets/secrets.yaml"
  elif [ -f "secrets.yaml" ]; then
    SOPS_FILE="secrets.yaml"
  else
    echo "Error: Could not find secrets.yaml. Please specify the path or run from the nix-config directory."
    exit 1
  fi
fi

if [ ! -f "$SOPS_FILE" ]; then
  echo "Error: $SOPS_FILE not found."
  exit 1
fi

EXTRACT_PATH='["'"$KEY_NAME"'"]'

sops --extract "$EXTRACT_PATH" --decrypt "$SOPS_FILE"
