#!/usr/bin/env bash
# Generate a new SSH key and store it in sops
# Usage: generate-ssh-key [--yes]

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

FORCE=false
if [ "${1:-}" == "--yes" ]; then
  FORCE=true
fi

if [ "$FORCE" = false ]; then
  gum confirm "This will overwrite the existing 'sshPrivKey' in secrets.yaml. Continue?" || exit 0
fi

METHOD=$(gum choose "Generate New Key" "Paste Existing Key")

TMP_DIR=$(mktemp -d)
KEY_FILE="$TMP_DIR/id_ed25519"

# Cleanup on exit
trap 'rm -rf "$TMP_DIR"' EXIT

if [ "$METHOD" == "Generate New Key" ]; then
  # Passphrase collection and verification
  while true; do
    PASSPHRASE=$(gum input --password --header "Enter passphrase (leave empty for none)" --placeholder "Passphrase")
    if [ -z "$PASSPHRASE" ]; then
      break
    fi
    VERIFY=$(gum input --password --header "Verify passphrase" --placeholder "Passphrase")
    if [ "$PASSPHRASE" == "$VERIFY" ]; then
      break
    fi
    echo "Passphrases do not match. Please try again."
  done

  # Description (Comment)
  DEFAULT_COMMENT="$USER@$(hostname)"
  COMMENT=$(gum input --header "Key Description (Comment)" --placeholder "$DEFAULT_COMMENT")
  [ -z "$COMMENT" ] && COMMENT="$DEFAULT_COMMENT"

  echo "Generating new Ed25519 key..."
  ssh-keygen -t ed25519 -f "$KEY_FILE" -N "$PASSPHRASE" -C "$COMMENT"
else
  echo "Paste your private key below:"
  gum write --placeholder "Paste Private Key Here" >"$KEY_FILE"

  # Ensure strict permissions
  chmod 600 "$KEY_FILE"

  # Ensure trailing newline (ssh-keygen requires it)
  if [ -n "$(tail -c1 "$KEY_FILE")" ]; then
    echo >>"$KEY_FILE"
  fi

  # Validate key
  echo "Validating key..."
  if ! ssh-keygen -y -f "$KEY_FILE" >/dev/null; then
    echo "Error: Invalid SSH private key."
    exit 1
  fi
fi

# Encode to JSON string for sops --set
# Use jq -Rs . to read the file preserving newlines
JSON_VALUE=$(jq --raw-input --slurp . <"$KEY_FILE")

echo "Storing private key in secrets.yaml..."
sops --set '["sshPrivKey"] '"$JSON_VALUE" "$SOPS_FILE"

# Sort the file alphabetically
echo "Sorting secrets.yaml..."
export EDITOR="yq --inplace 'sort_keys(..)'"
sops edit "$SOPS_FILE"

echo "SSH Key generated and stored successfully."
echo
echo "Extracting public key..."
extract-pub-key "$SOPS_FILE" "sshPrivKey"
