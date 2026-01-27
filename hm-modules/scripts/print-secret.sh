#!/usr/bin/env bash
# Print a secret from sops file
# Usage: print-secret <secret_name> [sops_file]

set -euo pipefail

KEY_NAME="${1:-}"
SOPS_FILE="${2:-}"

if [ -z "$KEY_NAME" ]; then
  echo "Usage: $(basename "$0") <secret_name> [sops_file]"
  exit 1
fi

# Find secrets.yaml if not specified
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

# Construct path with robust quoting
EXTRACT_PATH='["'"$KEY_NAME"'"]'

# Extract and print to stdout
sops --extract "$EXTRACT_PATH" --decrypt "$SOPS_FILE"
