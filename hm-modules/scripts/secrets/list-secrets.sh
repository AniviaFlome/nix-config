#!/usr/bin/env dash
# List secrets keys from sops file
# Usage: list-secrets [--json] [sops_file]

set -eu

JSON=false
SOPS_FILE=""

for arg in "$@"; do
  if [ "$arg" = "--json" ]; then
    JSON=true
  else
    SOPS_FILE="$arg"
  fi
done

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

if [ "$JSON" = true ]; then
  sops --decrypt "$SOPS_FILE" | yq --output-format json 'keys'
else
  sops --decrypt "$SOPS_FILE" | yq 'keys' | sed 's/^- //'
fi
