#!/usr/bin/env dash
# Create a new system age key and encrypt it
# Usage: create-system-key
# WARNING: This will overwrite existing secrets!

set -eu

# Color definitions
RED_BOLD='\033[1;31m'
GREEN='\033[0;32m'
YELLOW_BOLD='\033[1;33m'
NC='\033[0m'

SOPS_FILE=""

# Find secrets.yaml
if [ -f "secrets/secrets.yaml" ]; then
  SOPS_FILE="secrets/secrets.yaml"
elif [ -f "secrets.yaml" ]; then
  SOPS_FILE="secrets.yaml"
fi

printf "${RED_BOLD}WARNING: This will create a new age key.${NC}\n"
if [ -n "$SOPS_FILE" ]; then
  printf "${RED_BOLD}This will DELETE '$SOPS_FILE'. ALL EXISTING SECRETS WILL BE LOST.${NC}\n"
fi
echo

gum confirm "Continue?" || exit 0

echo "Generating new system age key..."
TMP_KEY=$(mktemp -u)
age-keygen --output "$TMP_KEY"

# Derive public key for .sops.yaml
AGE_PUB_KEY=$(age-keygen -y "$TMP_KEY")

echo
printf "${GREEN}Generated new age key with public key:${NC}\n"
echo "$AGE_PUB_KEY"
echo

# Encrypt the key with a passphrase
echo "Encrypting new key to keys.txt.age..."
echo "You will be prompted to enter a passphrase to protect this key."
echo "This passphrase will only be requested when deploying the key to the system."
printf "${YELLOW_BOLD}Please ensure it is strong.${NC}\n"
echo

age --passphrase --armor --output keys.txt.age "$TMP_KEY"

rm "$TMP_KEY"
echo
printf "${GREEN}✓ New system key created at keys.txt.age.${NC}\n"
echo

echo "Installing system key..."
ensure-system-key-exists

# Delete old secrets if they exist
if [ -n "$SOPS_FILE" ] && [ -f "$SOPS_FILE" ]; then
  echo
  echo "Removing old $SOPS_FILE..."
  rm -f "$SOPS_FILE"
fi

# Determine the secrets file location
if [ -d "secrets" ]; then
  SOPS_FILE="secrets/secrets.yaml"
else
  SOPS_FILE="secrets.yaml"
fi

# Initialize new secrets.yaml using the public key directly
echo
echo "Initializing new $SOPS_FILE with age recipient $AGE_PUB_KEY..."
echo "{}" | sops --encrypt --age "$AGE_PUB_KEY" --filename-override "$SOPS_FILE" --input-type json --output-type yaml --output "$SOPS_FILE" /dev/stdin

printf "${GREEN}✓ Created new $SOPS_FILE${NC}\n"

echo
printf "${YELLOW_BOLD}IMPORTANT: Update your .sops.yaml with this public key:${NC}\n"
echo "$AGE_PUB_KEY"
echo
echo "You can now add secrets using:"
echo "  set-secret"
echo "  set-hashed-password user"
echo "  set-hashed-password root"
echo "  generate-ssh-key"
