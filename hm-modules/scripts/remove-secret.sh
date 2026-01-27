#!/usr/bin/env bash
# Remove a secret from sops file
# Usage: remove-secret [secret_name] [sops_file]

set -euo pipefail

KEY_NAME="${1:-}"
SOPS_FILE="${2:-}"

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

if [ -z "$KEY_NAME" ]; then
  echo "Fetching secrets list..."
  SECRETS=$(list-secrets "$SOPS_FILE")
  KEY_NAME=$(echo "$SECRETS" | gum filter --placeholder "Select secret to remove")
fi

if [ -z "$KEY_NAME" ]; then
  echo "No secret selected."
  exit 1
fi

# Confirm removal
if gum confirm "Are you sure you want to remove '$KEY_NAME'?"; then
  echo "Removing secret '$KEY_NAME'..."

  # Use yq to delete key via sops edit mechanism
  export EDITOR="yq --inplace 'del(.[\"$KEY_NAME\"])'"
  sops edit "$SOPS_FILE"

  echo "Secret '$KEY_NAME' removed."
else
  echo "Cancelled."
  exit 0
fi
