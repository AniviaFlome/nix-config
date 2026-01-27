# Interactive secrets menu using gum

function press_any_key() {
  echo
  echo
  echo "Press any key to return to menu..."
  read -n 1 -s -r
}

function other_secrets_submenu() {
  while true; do
    CHOICE=$(@gum@ choose "List Secrets" "Print Secret" "Set Secret" "Remove Secret" "Copy Secret to Clipboard" "Edit Secrets" "Back")

    case "$CHOICE" in
      "List Secrets")
        list-secrets
        press_any_key
        ;;
      "Print Secret")
        SECRETS=$(list-secrets)
        SECRET=$(echo "$SECRETS" | @gum@ filter --placeholder "Select a secret to print...")
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
        SECRET=$(echo "$SECRETS" | @gum@ filter --placeholder "Select a secret to copy...")
        if [ -n "$SECRET" ]; then
          # We assume print-secret outputs only the secret value (which it does via sops --extract)
          print-secret "$SECRET" | @wlCopy@
          echo "Secret '$SECRET' copied to clipboard."
          press_any_key
        fi
        ;;
      "Edit Secrets")
        @sops@ edit secrets.yaml
        ;;
      "Back" | "")
        return
        ;;
    esac
  done
}

function set_github_token_logic() {
  TOKEN=$(@gum@ input --header "Enter GitHub Token" --placeholder "github_pat_...")
  if [ -n "$TOKEN" ]; then
     # Encode to JSON string for sops --set
     JSON_VALUE=$(@jq@ --null-input --arg v "$TOKEN" '$v')
     EXTRACT_PATH='["githubNixToken"]'
     
     echo "Setting githubNixToken..."
     @sops@ --set "$EXTRACT_PATH $JSON_VALUE" secrets.yaml
     
     echo "Sorting secrets.yaml..."
     export EDITOR="@yq@ --inplace 'sort_keys(..)'"
     @sops@ edit secrets.yaml
     
     echo "Token updated."
     press_any_key
  fi
}

function github_token_submenu() {
  while true; do
    CHOICE=$(@gum@ choose "Create Token" "Set Token" "Show Token" "Back")

    case "$CHOICE" in
      "Create Token")
        echo "You need to create a new Personal Access Token on GitHub."
        echo "URL: https://github.com/settings/personal-access-tokens/new"
        echo
        if @gum@ confirm "Open URL in browser?"; then
          echo "Attempting to open URL with xdg-open..."
          @xdgOpen@ "https://github.com/settings/personal-access-tokens/new" >/dev/null 2>&1 &
        else
          echo "Please open the URL manually."
        fi
        echo
        echo "Once you have copied the token, enter it below."
        set_github_token_logic
        ;;
      "Set Token")
        set_github_token_logic
        ;;
      "Show Token")
        print-secret githubNixToken
        press_any_key
        ;;
      "Back" | "")
        return
        ;;
    esac
  done
}

function ssh_key_submenu() {
  while true; do
    CHOICE=$(@gum@ choose "Extract Public Key" "Deploy Key to Remote Server" "Add/Recreate SSH key" "Back")

    case "$CHOICE" in
      "Extract Public Key")
        extract-pub-key secrets.yaml "sshPrivKey"
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

function system_key_submenu() {
  while true; do
    CHOICE=$(@gum@ choose "Ensure System Key Exists" "Create New System Key (new users start here)" "Back")

    case "$CHOICE" in
      "Ensure System Key Exists")
        ensure-system-key-exists
        press_any_key
        ;;
      "Create New System Key (new users start here)")
        create-system-key
        press_any_key
        ;;
      "Back" | "")
        return
        ;;
    esac
  done
}

function user_passwords_submenu() {
  while true; do
    CHOICE=$(@gum@ choose "Set User Password" "Set Root Password" "Back")

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
  CHOICE=$(@gum@ choose "Manage User Passwords" "Manage SSH Key" "Manage System Key (new users start here)" "Manage GitHub Token" "Manage Other Secrets" "Exit")

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
    "Manage GitHub Token")
      github_token_submenu
      ;;
    "Manage Other Secrets")
      other_secrets_submenu
      ;;
    "Exit" | "")
      exit 0
      ;;
  esac
done