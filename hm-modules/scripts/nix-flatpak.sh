#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

CONFIG_FILENAME="flatpak.nix"
DEFAULT_DIR="${HOME}/nix-config"
BACKUP_DIR="${XDG_STATE_HOME}/nix-flatpak-backups"
MAX_BACKUPS=14

# ============================================================================
# Colors
# ============================================================================
BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ============================================================================
# Helper Functions
# ============================================================================
msg_info() { echo -e "${GREEN}✓${NC} $1" >&2; }
msg_warn() { echo -e "${YELLOW}⚠${NC} $1" >&2; }
msg_error() { echo -e "${RED}✗${NC} $1" >&2; }

# ============================================================================
# Confirm + Diff + Apply
# ============================================================================
confirm_and_apply() {
  local original="$1"
  local temp="$2"

  # Empty check
  if [ ! -s "$temp" ]; then
    msg_error "Generated file is EMPTY. Aborting."
    rm -f "$temp"
    exit 1
  fi

  # Syntax check with debug
  local parse_log failed
  parse_log="$(mktemp)"
  if ! nix-instantiate --parse "$temp" >"$parse_log" 2>&1; then
    msg_error "Resulting file is NOT valid Nix syntax. Aborting."
    echo "nix-instantiate error:" >&2
    sed -n '1,25p' "$parse_log" >&2 || true
    failed="${temp}.failed.nix"
    mv "$temp" "$failed"
    echo "Broken file kept at: $failed" >&2
    rm -f "$parse_log"
    exit 1
  fi
  rm -f "$parse_log"

  echo -e "${YELLOW}--- DIFF ---${NC}"
  # Avoid pipefail killing us when diff returns 1 (files differ)
  (diff -u "$original" "$temp" | awk -v g="$GREEN" -v r="$RED" -v n="$NC" '
        /^@@/     { print $0; next }
        /^\+\+\+/ { print $0; next }
        /^---/    { print $0; next }
        /^\+/     { print g $0 n; next }
        /^-/      { print r $0 n; next }
        { print }
    ') || true
  echo -e "${YELLOW}-------------${NC}"

  read -rp "Apply changes? [Y/n] " answer
  if [[ -z ${answer:-} || $answer =~ ^[Yy]$ ]]; then
    mkdir -p "$BACKUP_DIR"

    # Human-readable timestamp, e.g. 2025-11-19_19-49-12
    local timestamp backup_name backup_path base
    timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
    base="$(basename "$original")"
    backup_name="${base}.${timestamp}.backup"
    backup_path="$BACKUP_DIR/$backup_name"

    # Save backup
    cp "$original" "$backup_path"

    # Enforce backup retention per file (keep newest MAX_BACKUPS)
    if [ -n "${MAX_BACKUPS:-}" ]; then
      mapfile -t backups < <(ls -1t "$BACKUP_DIR"/"${base}".*.backup 2>/dev/null || true)
      if [ "${#backups[@]}" -gt "$MAX_BACKUPS" ]; then
        for ((i = MAX_BACKUPS; i < ${#backups[@]}; i++)); do
          rm -f "${backups[$i]}"
        done
      fi
    fi

    mv "$temp" "$original"
    msg_info "Changes applied. Backup saved at: $backup_path"
  else
    msg_warn "Aborted. No changes applied."
    rm -f "$temp"
    exit 0
  fi
}

# ============================================================================
# Flake Root Detection + flatpak.nix discovery (recursive)
# ============================================================================
find_flake_root() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/flake.nix" ]; then
      echo "$dir"
      return
    fi
    dir="$(dirname "$dir")"
  done
  msg_error "flake.nix not found in parent paths."
  exit 1
}

if [ -n "${DEFAULT_DIR:-}" ] && [ -d "$DEFAULT_DIR" ]; then
  CONFIG_DIR="$DEFAULT_DIR"
else
  CONFIG_DIR="$(find_flake_root)"
fi

find_single_file() {
  local pattern="$1"
  local matches=()

  while IFS= read -r f; do
    matches+=("$f")
  done < <(find "$CONFIG_DIR" -type f -name "$pattern")

  if [ "${#matches[@]}" -eq 0 ]; then
    echo ""
    return
  fi

  if [ "${#matches[@]}" -gt 1 ]; then
    msg_error "Multiple '$pattern' files found under flake root:"
    printf ' - %s\n' "${matches[@]}"
    exit 1
  fi

  echo "${matches[0]}"
}

DEFAULT_CONFIG="$(find_single_file "$CONFIG_FILENAME")"

[ -z "$DEFAULT_CONFIG" ] && msg_warn "$CONFIG_FILENAME not found."

# ============================================================================
# Validation
# ============================================================================
check_dependencies() {
  local missing=()
  command -v fzf >/dev/null || missing+=("fzf")
  command -v flatpak >/dev/null || missing+=("flatpak")
  command -v nix-instantiate >/dev/null || missing+=("nix-instantiate")

  if [ ${#missing[@]} -ne 0 ]; then
    msg_error "Missing dependencies: ${missing[*]}"
    exit 1
  fi
}

check_config_file() {
  if [ ! -f "$1" ]; then
    msg_error "Config file not found: $1"
    exit 1
  fi
  if [ ! -w "$1" ]; then
    msg_error "Config not writable: $1"
    exit 1
  fi
}

# ============================================================================
# Parsing
# ============================================================================

extract_flatpak_packages() {
  local file="$1"

  awk '
    BEGIN { in_packages=0; in_list=0 }

    /services\.flatpak\.packages/ || /packages[[:space:]]*=/ {
        in_packages=1
        next
    }

    in_packages && !in_list && index($0, "[") > 0 {
        in_list=1
        next
    }

    in_list {
        line=$0
        stripped=line
        gsub(/^[ \t]+/, "", stripped)
        gsub(/[ \t]+$/, "", stripped)

        # closing bracket
        if (stripped ~ /^\];?$/ || stripped ~ /^\];/ || stripped ~ /^\]/) {
            in_list=0
            exit
        }

        if (stripped == "" || stripped ~ /^#/ || index(stripped, "[") > 0) {
            next
        }

        pkg=stripped
        gsub(/"/, "", pkg) # Remove quotes
        if (pkg != "") print pkg
        next
    }
    ' "$file"
}

# ============================================================================
# Selection
# ============================================================================

select_flatpak_to_add() {
  local selected app_id

  # Use flatpak search and format output for fzf
  # Format: "Application ID | Name - Description"
  selected="$(flatpak search "" --columns=application,name,description |
    awk -F'\t' '{printf "%s | %s - %s\n", $1, $2, $3}' |
    fzf --prompt='Search Flatpak > ' \
      --border --reverse --ansi \
      --exact \
      --tiebreak=begin,length \
      --with-nth=2.. \
      --delimiter='\|')" || return 1

  [ -z "$selected" ] && return 1

  # Extract Application ID (first column)
  app_id="$(echo "$selected" | awk -F' | ' '{print $1}')"

  # Trim whitespace
  app_id="${app_id//[[:space:]]/}"

  if [[ -z $app_id ]]; then
    msg_error "Invalid selection: '$selected' → parsed empty application ID"
    return 1
  fi

  echo "$app_id"
}

select_flatpak_to_remove() {
  local file="$1"

  extract_flatpak_packages "$file" |
    fzf \
      --prompt='Select Flatpak to remove > ' \
      --border --reverse --ansi \
      --exact \
      --tiebreak=begin,length
}

# ============================================================================
# Add
# ============================================================================

add_flatpak_package() {
  local file="$1"
  local app_id="$2"

  if ! grep -qE "services\.flatpak\.packages|packages[[:space:]]*=" "$file"; then
    msg_error "services.flatpak.packages block missing — abort."
    exit 1
  fi

  # Check if already exists
  if grep -q "\"$app_id\"" "$file"; then
    msg_warn "Already exists: $app_id"
    exit 0
  fi

  local temp
  temp="$(mktemp)"

  awk -v app_id="$app_id" '
        BEGIN { in_packages=0; in_list=0; inserted=0 }

        /services\.flatpak\.packages/ || /packages[[:space:]]*=/ {
            in_packages=1
            print
            next
        }

        in_packages && !in_list && index($0, "[") > 0 {
            in_list=1
            print
            next
        }

        in_list {
            line=$0
            stripped=line
            gsub(/^[ \t]+/, "", stripped)
            gsub(/[ \t]+$/, "", stripped)

            is_closing = (stripped ~ /^\];?$/ || stripped ~ /^\];/ || stripped ~ /^\]/)
            is_item = (stripped != "" && stripped !~ /^#/ && index(stripped, "[") == 0 && !is_closing)

            if (is_item && !inserted) {
                cur=stripped
                gsub(/"/, "", cur)
                if (app_id < cur) {
                    print "          \"" app_id "\""
                    inserted=1
                }
            }

            if (is_closing && !inserted) {
                print "          \"" app_id "\""
                inserted=1
            }

            print line

            if (is_closing) {
                in_list=0
                in_packages=0
            }
            next
        }

        { print }
    ' "$file" >"$temp"

  confirm_and_apply "$file" "$temp"
}

# ============================================================================
# Remove
# ============================================================================

remove_flatpak_package() {
  local file="$1"
  local pkg="$2"

  if ! grep -qE "services\.flatpak\.packages|packages[[:space:]]*=" "$file"; then
    msg_error "services.flatpak.packages block missing — abort."
    exit 1
  fi

  local temp
  temp="$(mktemp)"

  awk -v target="$pkg" '
        BEGIN { in_packages=0; in_list=0 }

        /services\.flatpak\.packages/ || /packages[[:space:]]*=/ {
            in_packages=1
            print
            next
        }

        in_packages && !in_list && index($0, "[") > 0 {
            in_list=1
            print
            next
        }

        in_list {
            line=$0
            stripped=line
            gsub(/^[ \t]+/, "", stripped)
            gsub(/[ \t]+$/, "", stripped)

            is_closing = (stripped ~ /^\];?$/ || stripped ~ /^\];/ || stripped ~ /^\]/)
            is_item = (stripped != "" && stripped !~ /^#/ && index(stripped, "[") == 0 && !is_closing)

            if (is_item) {
                cur=stripped
                gsub(/"/, "", cur)
                if (cur == target) {
                    # skip this line
                    if (is_closing) {
                        in_list=0
                        in_packages=0
                    }
                    next
                }
            }

            print line

            if (is_closing) {
                in_list=0
                in_packages=0
            }
            next
        }

        { print }
    ' "$file" >"$temp"

  confirm_and_apply "$file" "$temp"
}

# ============================================================================
# Usage
# ============================================================================
show_usage() {
  echo -e "${BOLD}nix-flatpak${NC} — Add/Remove Flatpak packages"
  echo "Usage:"
  echo "  nix-flatpak add    [FILE]"
  echo "  nix-flatpak remove [FILE]"
}

# ============================================================================
# Commands
# ============================================================================
cmd_add() {
  local file=""

  while [ $# -gt 0 ]; do
    case "$1" in
    -h | --help)
      show_usage
      exit 0
      ;;
    *) file="$1" ;;
    esac
    shift
  done

  if [ -z "${file:-}" ]; then
    file="$DEFAULT_CONFIG"
  fi

  check_dependencies
  check_config_file "$file"

  local app_id
  if ! app_id="$(select_flatpak_to_add)"; then
    msg_warn "No flatpak selected."
    exit 0
  fi
  add_flatpak_package "$file" "$app_id"
}

cmd_remove() {
  local file=""

  while [ $# -gt 0 ]; do
    case "$1" in
    -h | --help)
      show_usage
      exit 0
      ;;
    *) file="$1" ;;
    esac
    shift
  done

  if [ -z "${file:-}" ]; then
    file="$DEFAULT_CONFIG"
  fi

  check_dependencies
  check_config_file "$file"

  local pkg
  pkg="$(select_flatpak_to_remove "$file" || true)"
  [ -z "$pkg" ] && msg_warn "No package selected." && exit 0

  remove_flatpak_package "$file" "$pkg"
}

main() {
  [ $# -eq 0 ] && show_usage && exit 1

  case "$1" in
  add)
    shift
    cmd_add "$@"
    ;;
  remove)
    shift
    cmd_remove "$@"
    ;;
  -h | --help) show_usage ;;
  *)
    msg_error "Unknown command: $1"
    exit 1
    ;;
  esac
}

main "$@"
