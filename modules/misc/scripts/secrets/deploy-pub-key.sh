#!/usr/bin/env dash
# Deploy public key to remote host
# Usage: deploy-pub-key [options] [username] [host]

set -eu

USERNAME=""
HOST=""
PORT=""

while [ $# -gt 0 ]; do
  case "$1" in
  -p | --port)
    PORT="$2"
    shift 2
    ;;
  -*)
    echo "Unknown option: $1"
    exit 1
    ;;
  *)
    if [ -z "$USERNAME" ]; then
      USERNAME="$1"
    elif [ -z "$HOST" ]; then
      HOST="$1"
    fi
    shift
    ;;
  esac
done

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

if [ -z "$PORT" ]; then
  echo "Enter port:"
  PORT=$(gum input --placeholder "22")
  if [ -z "$PORT" ]; then
    PORT="22"
  fi
fi

if [ -z "$HOST" ]; then
  echo "Host is required."
  exit 1
fi

echo "Deploying key to $USERNAME@$HOST..."

PUB_KEY=$(extract-pub-key 2>/dev/null | grep "^ssh-" || true)

if [ -z "$PUB_KEY" ]; then
  echo "Failed to extract public key or key format not recognized."
  echo "Running extract-pub-key to show output:"
  extract-pub-key
  exit 1
fi

TMP_PUB=$(mktemp --suffix=.pub)
echo "$PUB_KEY" >"$TMP_PUB"

trap 'rm -f "$TMP_PUB"' EXIT

if [ -n "$PORT" ]; then
  ssh-copy-id -p "$PORT" -f -i "$TMP_PUB" "$USERNAME@$HOST"
else
  ssh-copy-id -f -i "$TMP_PUB" "$USERNAME@$HOST"
fi

echo "Key deployed successfully to $USERNAME@$HOST"
