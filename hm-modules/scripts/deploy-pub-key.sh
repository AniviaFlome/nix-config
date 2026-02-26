#!/usr/bin/env dash
# Deploy public key to remote host
# Usage: deploy-pub-key [username] [host]

set -eu

USERNAME="${1:-}"
HOST="${2:-}"

if [ -z "$USERNAME" ]; then
  echo "Enter username:"
  USERNAME=$(gum input --placeholder "$USER")
  if [ -z "$USERNAME" ]; then
    USERNAME="$USER"
  fi
fi

if [ -z "$HOST" ]; then
  echo "Enter host:"
  HOST=$(gum input --placeholder "Host (e.g. 192.168.1.10)")
fi

if [ -z "$HOST" ]; then
  echo "Host is required."
  exit 1
fi

echo "Deploying key to $USERNAME@$HOST..."

# Extract public key (filter for ssh- prefixed lines)
PUB_KEY=$(extract-pub-key 2>/dev/null | grep "^ssh-" || true)

if [ -z "$PUB_KEY" ]; then
  echo "Failed to extract public key or key format not recognized."
  echo "Running extract-pub-key to show output:"
  extract-pub-key
  exit 1
fi

# Use a temp file for ssh-copy-id
# ssh-copy-id often requires the file to end in .pub
TMP_PUB=$(mktemp --suffix=.pub)
echo "$PUB_KEY" >"$TMP_PUB"

# Cleanup on exit
trap 'rm -f "$TMP_PUB"' EXIT

ssh-copy-id -f -i "$TMP_PUB" "$USERNAME@$HOST"

echo "Key deployed successfully to $USERNAME@$HOST"
