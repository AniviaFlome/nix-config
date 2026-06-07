#!/usr/bin/env dash
# Decrypts and installs the sops age key to the system location
# Usage: ensure-system-key-exists [OPTIONS]

set -eu

GREEN='\033[0;32m'
YELLOW_BOLD='\033[1;33m'
CYAN='\033[0;36m'
RED_BOLD='\033[1;31m'
NC='\033[0m'

SYSTEM_KEY_FILE="${SOPS_AGE_KEY_FILE:-/var/lib/sops/age-keys.txt}"

FORCE=false

show_help() {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo
  echo "Decrypts and installs the sops age key to the system location."
  echo
  echo "Options:"
  echo "  -h, --help       Show this help message and exit"
  echo "  -f, --force      Overwrite the key file if it already exists (implied if content differs)"
  echo
  echo "Environment:"
  echo "  SOPS_AGE_KEY_FILE  Path to install the key to (default: /var/lib/sops/age-keys.txt)"
}

while [ $# -gt 0 ]; do
  case "$1" in
  -h | --help)
    show_help
    exit 0
    ;;
  -f | --force)
    FORCE=true
    shift
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

echo "We need to decrypt the master key to unlock your secrets."
echo

printf "${CYAN}Please enter your passphrase when prompted by ${YELLOW_BOLD}age${CYAN}...${NC}\n"

TMP_KEY=$(mktemp) || {
  echo "Failed to create temp file"
  exit 1
}

AGE_FILE="keys.txt.age"
if [ ! -f "$AGE_FILE" ]; then
  printf "${RED_BOLD}✗ Could not find encrypted key file at $AGE_FILE${NC}\n"
  rm -f "$TMP_KEY"
  exit 1
fi

if age --decrypt --output "$TMP_KEY" "$AGE_FILE"; then
  echo
  printf "${GREEN}✓ Successfully decrypted key to temporary file.${NC}\n"

  if [ -f "$SYSTEM_KEY_FILE" ]; then
    if cmp -s "$TMP_KEY" "$SYSTEM_KEY_FILE" && [ "$FORCE" = false ]; then
      printf "${GREEN}✓ System master key is already up to date at $SYSTEM_KEY_FILE${NC}\n"
      rm -f "$TMP_KEY"
      exit 0
    else
      printf "${YELLOW_BOLD}System key differs or force enabled. Updating $SYSTEM_KEY_FILE...${NC}\n"
    fi
  else
    printf "${CYAN}Installing master key to system location ($SYSTEM_KEY_FILE)...${NC}\n"
  fi

  if sudo mkdir -p "$(dirname "$SYSTEM_KEY_FILE")" &&
    sudo cp "$TMP_KEY" "$SYSTEM_KEY_FILE" &&
    sudo chown root:wheel "$SYSTEM_KEY_FILE" &&
    sudo chmod 440 "$SYSTEM_KEY_FILE"; then
    printf "${GREEN}✓ Successfully installed key to system location!${NC}\n"
  else
    printf "${RED_BOLD}✗ Failed to install key to system location.${NC}\n"
    rm -f "$TMP_KEY"
    exit 1
  fi

  rm -f "$TMP_KEY"
else
  echo
  printf "${RED_BOLD}✗ Decryption failed.${NC}\n"
  echo "Please check your passphrase and try again."
  rm -f "$TMP_KEY"
  exit 1
fi
