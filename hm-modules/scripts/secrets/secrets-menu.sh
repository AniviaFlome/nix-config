#!/usr/bin/env dash
# Interactive secrets menu using gum

set -eu

press_any_key() {
  echo
  echo
  echo "Press Enter to return to menu..."
  read -r _
}

other_secrets_submenu() {
  while true; do
    CHOICE=$(gum choose "List Secrets" "Print Secret" "Set Secret" "Remove Secret" "Copy Secret to Clipboard" "Edit Secrets" "Back")

    case "$CHOICE" in
    "List Secrets")
      list-secrets
      press_any_key
      ;;
    "Print Secret")
      SECRETS=$(list-secrets)
      SECRET=$(echo "$SECRETS" | gum filter --placeholder "Select a secret to print...")
      if [ -n "$SECRET" ]; then
        print-secret "$SECRET"
        press_any_key
      fi
      ;;
    "Set Secret")
      set-secret
      press_any_key
      ;;
    "Remove Secret")
      remove-secret
      press_any_key
      ;;
    "Copy Secret to Clipboard")
      SECRETS=$(list-secrets)
      SECRET=$(echo "$SECRETS" | gum filter --placeholder "Select a secret to copy...")
      if [ -n "$SECRET" ]; then
        print-secret "$SECRET" | wl-copy
        echo "Secret '$SECRET' copied to clipboard."
        press_any_key
      fi
      ;;
    "Edit Secrets")
      if [ -f "secrets/secrets.yaml" ]; then
        sops edit secrets/secrets.yaml
      else
        sops edit secrets.yaml
      fi
      ;;
    "Back" | "")
      return
      ;;
    esac
  done
}

ssh_key_submenu() {
  while true; do
    CHOICE=$(gum choose "Extract Public Key" "Deploy Key to Remote Server" "Add/Recreate SSH key" "Back")

    case "$CHOICE" in
    "Extract Public Key")
      extract-pub-key
      press_any_key
      ;;
    "Deploy Key to Remote Server")
      deploy-pub-key
      press_any_key
      ;;
    "Add/Recreate SSH key")
      generate-ssh-key
      press_any_key
      ;;
    "Back" | "")
      return
      ;;
    esac
  done
}

system_key_submenu() {
  while true; do
    CHOICE=$(gum choose "Ensure System Key Exists (new users start here)" "Create New System Key" "Back")

    case "$CHOICE" in
    "Ensure System Key Exists (new users start here)")
      ensure-system-key-exists
      press_any_key
      ;;
    "Create New System Key")
      create-system-key
      press_any_key
      ;;
    "Back" | "")
      return
      ;;
    esac
  done
}

user_passwords_submenu() {
  while true; do
    CHOICE=$(gum choose "Set User Password" "Set Root Password" "Back")

    case "$CHOICE" in
    "Set User Password")
      set-hashed-password user
      press_any_key
      ;;
    "Set Root Password")
      set-hashed-password root
      press_any_key
      ;;
    "Back" | "")
      return
      ;;
    esac
  done
}

while true; do
  CHOICE=$(gum choose "Manage User Passwords" "Manage SSH Key" "Manage System Key (new users start here)" "Manage Other Secrets" "Exit")

  case "$CHOICE" in
  "Manage User Passwords")
    user_passwords_submenu
    ;;
  "Manage SSH Key")
    ssh_key_submenu
    ;;
  "Manage System Key (new users start here)")
    system_key_submenu
    ;;
  "Manage Other Secrets")
    other_secrets_submenu
    ;;
  "Exit" | "")
    exit 0
    ;;
  esac
done
