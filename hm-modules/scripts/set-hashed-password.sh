#!/usr/bin/env bash
# Set user or root password (hashed)
# Usage: set-hashed-password [user|root]

set -euo pipefail

SOPS_FILE=""

# Find secrets.yaml
if [ -f "secrets/secrets.yaml" ]; then
  SOPS_FILE="secrets/secrets.yaml"
elif [ -f "secrets.yaml" ]; then
  SOPS_FILE="secrets.yaml"
else
  echo "Error: Could not find secrets.yaml. Please run from the nix-config directory."
  exit 1
fi

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  TARGET=$(gum choose "user" "root")
fi

if [ "$TARGET" == "root" ]; then
  SECRET_KEY="unixRootPassword"
else
  SECRET_KEY="unixPassword"
fi

while true; do
  PASSWORD=$(gum input --password --placeholder "Enter new password for $TARGET")
  if [ -z "$PASSWORD" ]; then
    echo "Password cannot be empty."
    continue
  fi
  CONFIRM=$(gum input --password --placeholder "Confirm password")
  if [ "$PASSWORD" == "$CONFIRM" ]; then
    break
  fi
  echo "Passwords do not match. Try again."
done

echo "Hashing password..."
HASH=$(echo "$PASSWORD" | mkpasswd --method=yescrypt --stdin)

# Encode to JSON string for sops --set
JSON_VALUE=$(jq --null-input --arg v "$HASH" '$v')
EXTRACT_PATH='["'"$SECRET_KEY"'"]'

echo "Setting $SECRET_KEY..."
sops --set "$EXTRACT_PATH $JSON_VALUE" "$SOPS_FILE"

echo "Sorting secrets.yaml..."
export EDITOR="yq --inplace 'sort_keys(..)'"
sops edit "$SOPS_FILE"

echo "Password for $TARGET updated."
