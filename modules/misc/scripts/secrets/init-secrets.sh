#!/usr/bin/env dash
# Non-interactive secrets initialization
# Usage: init-secrets --passphrase <passphrase> --password <password> --ssh-comment <comment>
#                     [--key-output <path>] [--no-install-key] [--dir <secrets-repo-dir>]

set -eu

PASSPHRASE=""
PASSWORD=""
SSH_COMMENT=""
KEY_OUTPUT=""
INSTALL_KEY=true
DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
  --passphrase)
    PASSPHRASE="$2"
    shift 2
    ;;
  --password)
    PASSWORD="$2"
    shift 2
    ;;
  --ssh-comment)
    SSH_COMMENT="$2"
    shift 2
    ;;
  --key-output)
    KEY_OUTPUT="$2"
    shift 2
    ;;
  --no-install-key)
    INSTALL_KEY=false
    shift
    ;;
  --dir)
    DIR="$2"
    shift 2
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

if [ -z "$PASSPHRASE" ] || [ -z "$PASSWORD" ] || [ -z "$SSH_COMMENT" ]; then
  echo "Usage: init-secrets --passphrase <passphrase> --password <password> --ssh-comment <comment>"
  echo "  [--key-output <path>]    Write decrypted age key to this path"
  echo "  [--no-install-key]       Skip installing system key via sudo"
  echo "  [--dir <path>]           Secrets repo directory (default: cwd)"
  exit 1
fi

if [ -n "$DIR" ]; then
  cd "$DIR"
fi

SYSTEM_KEY_FILE="${SOPS_AGE_KEY_FILE:-/var/lib/sops/age-keys.txt}"

echo "Generating new system age key..."
TMP_KEY=$(mktemp -u)
age-keygen --output "$TMP_KEY"

AGE_PUB_KEY=$(age-keygen -y "$TMP_KEY")

echo "Encrypting key to keys.txt.age..."
printf '%s\n%s\n' "$PASSPHRASE" "$PASSPHRASE" | script -qc "age --passphrase --armor --output keys.txt.age $TMP_KEY" /dev/null >/dev/null

if [ "$INSTALL_KEY" = true ]; then
  echo "Installing system key..."
  sudo mkdir -p "$(dirname "$SYSTEM_KEY_FILE")"
  sudo cp "$TMP_KEY" "$SYSTEM_KEY_FILE"
  sudo chown root:wheel "$SYSTEM_KEY_FILE"
  sudo chmod 440 "$SYSTEM_KEY_FILE"
fi

if [ -n "$KEY_OUTPUT" ]; then
  echo "Writing decrypted key to $KEY_OUTPUT..."
  cp "$TMP_KEY" "$KEY_OUTPUT"
fi

export SOPS_AGE_KEY=$(cat "$TMP_KEY")

echo "Initializing secrets.yaml..."
rm -f .sops.yaml secrets.yaml
echo "{}" | sops --encrypt --age "$AGE_PUB_KEY" --filename-override secrets.yaml --input-type json --output-type yaml --output secrets.yaml /dev/stdin

echo "Setting user password..."
HASH=$(echo "$PASSWORD" | mkpasswd --method=yescrypt --stdin)
JSON_VALUE=$(jq --null-input --arg v "$HASH" '$v')
sops --set '["unixPassword"] '"$JSON_VALUE" secrets.yaml

echo "Setting root password..."
sops --set '["unixRootPassword"] '"$JSON_VALUE" secrets.yaml

echo "Generating SSH key..."
TMP_DIR=$(mktemp -d)
KEY_FILE="$TMP_DIR/id_ed25519"
ssh-keygen -t ed25519 -f "$KEY_FILE" -N "" -C "$SSH_COMMENT"

JSON_VALUE=$(jq --raw-input --slurp . <"$KEY_FILE")
sops --set '["sshPrivKey"] '"$JSON_VALUE" secrets.yaml

echo "Sorting secrets.yaml..."
export EDITOR="yq --inplace 'sort_keys(..)'"
sops edit secrets.yaml

echo "Extracting public key..."
PUB_KEY=$(ssh-keygen -y -f "$KEY_FILE")
rm -rf "$TMP_DIR"

rm -f "$TMP_KEY"

echo "Secrets initialization complete."
