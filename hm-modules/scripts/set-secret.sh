#!/usr/bin/env bash
# Set a secret in sops file
# Usage: set-secret [sops_file]

set -euo pipefail

SOPS_FILE="${1:-}"

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

echo "Enter Secret Name:"
KEY_NAME=$(gum input --placeholder "Secret Name")

if [ -z "$KEY_NAME" ]; then
  echo "Secret Name is required."
  exit 1
fi

echo "Enter Secret Value:"
VALUE=$(gum write --placeholder "Secret Value")

if [ -z "$VALUE" ]; then
  echo "Secret Value is required."
  exit 1
fi

# Encode value to JSON string for sops --set
JSON_VALUE=$(jq --null-input --arg v "$VALUE" '$v')

# Construct path
EXTRACT_PATH='["'"$KEY_NAME"'"]'

echo "Setting secret '$KEY_NAME'..."
# sops --set expects "path value" as a single argument string
sops --set "$EXTRACT_PATH $JSON_VALUE" "$SOPS_FILE"

echo "Sorting keys alphabetically..."
# Use yq to sort keys via sops edit mechanism
export EDITOR="yq --inplace 'sort_keys(..)'"
sops edit "$SOPS_FILE"

echo "Secret '$KEY_NAME' saved successfully."
