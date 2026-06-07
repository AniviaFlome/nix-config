#!/usr/bin/env dash
# Extract public key from sops secret
# Usage: extract-pub-key [sops_file] [key_name]

set -eu

SOPS_FILE="${1:-}"
KEY_NAME="${2:-sshPrivKey}"

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

TMP_KEY=$(mktemp)
chmod 600 "$TMP_KEY"

trap 'rm -f "$TMP_KEY"' EXIT

echo "Extracting '$KEY_NAME' from '$SOPS_FILE'..."
print-secret "$KEY_NAME" "$SOPS_FILE" >"$TMP_KEY"

if [ ! -s "$TMP_KEY" ]; then
  echo "Error: Failed to extract key '$KEY_NAME' from '$SOPS_FILE' or key is empty."
  exit 1
fi

echo "Generating public key... you may be prompted for your SSH private key passphrase."
echo
PUB_KEY=$(ssh-keygen -y -f "$TMP_KEY")

if [ $? -eq 0 ] && [ -n "$PUB_KEY" ]; then
  echo "Public key:"
  echo "$PUB_KEY"
  echo

  if command -v wl-copy >/dev/null 2>&1; then
    echo "$PUB_KEY" | wl-copy
    echo "Public key copied to clipboard."
  fi
else
  echo "Error: Failed to extract public key."
  exit 1
fi
