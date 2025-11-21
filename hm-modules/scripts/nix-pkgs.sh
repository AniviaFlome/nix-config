#!/usr/bin/env bash
set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

PKG_PREFIX="pkgs"
USE_STABLE=false

BACKUP_DIR="${XDG_STATE_HOME}/nix-pkgs-backups"
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
# Confirm + Diff + Apply (default = YES, colored, backup dir, 14 backups)
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
# Flake Root Detection + pkgs.nix discovery (recursive)
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

CONFIG_DIR="$(find_flake_root)"

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

DEFAULT_CONFIG="$(find_single_file 'pkgs.nix')"
DEFAULT_CONFIG_STABLE="$(find_single_file 'pkgs-stable.nix')"

[ -z "$DEFAULT_CONFIG" ] && msg_error "No pkgs.nix found under flake root." && exit 1
[ -z "$DEFAULT_CONFIG_STABLE" ] && msg_warn "pkgs-stable.nix not found (stable mode will only work with explicit file)."

# ============================================================================
# Validation
# ============================================================================
check_dependencies() {
  local missing=()
  command -v fzf >/dev/null || missing+=("fzf")
  command -v nix-search-tv >/dev/null || missing+=("nix-search-tv")
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
get_package_name() {
  # strip current PKG_PREFIX (pkgs or pkgs.stable) from attr path
  echo "$1" | sed "s/^${PKG_PREFIX}\.//"
}

# Extract bare package names from environment.systemPackages list
extract_packages() {
  local file="$1"

  awk '
    BEGIN { in_env=0; in_list=0 }

    /environment\.systemPackages/ {
        in_env=1
        if (index($0, "[") > 0) {
            in_list=1
        }
        next
    }

    in_env && !in_list && index($0, "[") == 0 {
        # lines between env line and "[" (like with pkgs;)
        next
    }

    in_env && !in_list && index($0, "[") > 0 {
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
        gsub(/^pkgs\./, "", pkg)
        gsub(/^pkgs\.stable\./, "", pkg)
        gsub(/[ \t].*$/, "", pkg)
        if (pkg != "") print pkg
        next
    }
    ' "$file"
}

# ============================================================================
# nix-search-tv based selection (fzf)
# ============================================================================
select_package_to_add() {
  local selected raw clean pkg

  # fzf UI
  selected="$(
    nix-search-tv print nixpkgs |
      fzf \
        --prompt='Search nixpkgs package > ' \
        --preview 'nix-search-tv preview {}' \
        --border --reverse --ansi
  )" || return 1

  [ -z "$selected" ] && return 1

  # Extract first token-like part (before tab or pipe)
  # This strips descriptions and metadata that FZF often includes after the package path.
  raw="${selected%%$'\t'*}"
  raw="${raw%%|*}"

  # --- Attribute Path Normalization ---

  # 1. Remove all spaces
  raw="${raw//[[:space:]]/}"

  # 2. Convert slashes (path format) to dots (Nix attribute format)
  clean="${raw//\//.}"

  # 3. Strip the standard nixpkgs. prefix if present
  clean="${clean#nixpkgs.}"

  pkg="$clean"

  # --- Generic Prefix Deduplication ---
  # This fixes issues like 'nur.nur.repos...' or 'gnome.gnome.terminal'
  # where the top-level package set name is duplicated in the attribute path.

  # Extract the first segment (e.g., 'nur' or 'gnome')
  local first_segment="${pkg%%.*}"

  # Check if the remaining string immediately starts with the same segment again
  if [[ $pkg == "$first_segment.$first_segment."* ]]; then
    # Strip the first instance of the duplicate prefix and the trailing dot
    pkg="${pkg#$first_segment.}"
  fi

  if [[ -z $pkg ]]; then
    msg_error "Invalid selection: '$selected' → parsed empty package name"
    return 1
  fi

  echo "$pkg"
}

select_package_to_remove() {
  local file="$1"

  extract_packages "$file" |
    fzf \
      --prompt='Select package to remove > ' \
      --border --reverse --ansi
}

# ============================================================================
# Add (alphabetical, respects with pkgs / with pkgs.stable)
# ============================================================================
add_package() {
  local file="$1"
  local attr="$2"

  if ! grep -q "environment\.systemPackages" "$file"; then
    msg_error "systemPackages block missing — abort."
    exit 1
  fi

  local bare
  bare="$(get_package_name "$attr")"

  # crude duplicate guard (by bare name)
  if grep -q "\\b$bare\\b" "$file"; then
    msg_warn "Already exists: $bare"
    exit 0
  fi

  local prefItem="$PKG_PREFIX.$bare"
  local temp
  temp="$(mktemp)"

  awk -v bare="$bare" -v prefItem="$prefItem" '
        BEGIN { in_env=0; in_list=0; inserted=0; use_bare=0 }

        /environment\.systemPackages/ {
            in_env=1
            if ($0 ~ /with[ \t]+pkgs[ \t]*;/ || $0 ~ /with[ \t]+pkgs\.stable[ \t]*;/) {
                use_bare=1
            }
            print
            if (index($0, "[") > 0) {
                in_list=1
            }
            next
        }

        in_env && !in_list && index($0, "[") == 0 {
            if ($0 ~ /with[ \t]+pkgs[ \t]*;/ || $0 ~ /with[ \t]+pkgs\.stable[ \t]*;/) {
                use_bare=1
            }
            print
            next
        }

        in_env && !in_list && index($0, "[") > 0 {
            if ($0 ~ /with[ \t]+pkgs[ \t]*;/ || $0 ~ /with[ \t]+pkgs\.stable[ \t]*;/) {
                use_bare=1
            }
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
                gsub(/^pkgs\./, "", cur)
                gsub(/^pkgs\.stable\./, "", cur)
                gsub(/[ \t].*$/, "", cur)
                if (bare < cur) {
                    item=(use_bare ? bare : prefItem)
                    print "    " item
                    inserted=1
                }
            }

            if (is_closing && !inserted) {
                item=(use_bare ? bare : prefItem)
                print "    " item
                inserted=1
            }

            print line

            if (is_closing) {
                in_list=0
                in_env=0
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
remove_package() {
  local file="$1"
  local pkg="$2"

  if ! grep -q "environment\.systemPackages" "$file"; then
    msg_error "systemPackages block missing — abort."
    exit 1
  fi

  local temp
  temp="$(mktemp)"

  awk -v target="$pkg" '
        BEGIN { in_env=0; in_list=0 }

        /environment\.systemPackages/ {
            in_env=1
            print
            if (index($0, "[") > 0) {
                in_list=1
            }
            next
        }

        in_env && !in_list && index($0, "[") == 0 {
            print
            next
        }

        in_env && !in_list && index($0, "[") > 0 {
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
                gsub(/^pkgs\./, "", cur)
                gsub(/^pkgs\.stable\./, "", cur)
                gsub(/[ \t].*$/, "", cur)
                if (cur == target) {
                    # skip this line
                    if (is_closing) {
                        in_list=0
                        in_env=0
                    }
                    next
                }
            }

            print line

            if (is_closing) {
                in_list=0
                in_env=0
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
  echo -e "${BOLD}nix-pkgs${NC} — Add packages easily to your config"
  echo "Usage:"
  echo "  nix-pkgs add    [--stable] [FILE]"
  echo "  nix-pkgs remove [--stable] [FILE]"
}

# ============================================================================
# Commands
# ============================================================================
cmd_add() {
  local file=""

  while [ $# -gt 0 ]; do
    case "$1" in
    -s | --stable)
      USE_STABLE=true
      PKG_PREFIX="pkgs.stable"
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    *) file="$1" ;;
    esac
    shift
  done

  if [ -z "${file:-}" ]; then
    if [ "$USE_STABLE" = true ] && [ -n "$DEFAULT_CONFIG_STABLE" ]; then
      file="$DEFAULT_CONFIG_STABLE"
    else
      file="$DEFAULT_CONFIG"
    fi
  fi

  check_dependencies
  check_config_file "$file"

  local pkg full_attr
  if ! pkg="$(select_package_to_add)"; then
    msg_warn "No package selected."
    exit 0
  fi

  full_attr="${PKG_PREFIX}.${pkg}"
  add_package "$file" "$full_attr"
}

cmd_remove() {
  local file=""

  while [ $# -gt 0 ]; do
    case "$1" in
    -s | --stable)
      USE_STABLE=true
      PKG_PREFIX="pkgs.stable"
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    *) file="$1" ;;
    esac
    shift
  done

  if [ -z "${file:-}" ]; then
    if [ "$USE_STABLE" = true ] && [ -n "$DEFAULT_CONFIG_STABLE" ]; then
      file="$DEFAULT_CONFIG_STABLE"
    else
      file="$DEFAULT_CONFIG"
    fi
  fi

  check_dependencies
  check_config_file "$file"

  local pkg
  pkg="$(select_package_to_remove "$file" || true)"
  [ -z "$pkg" ] && msg_warn "No package selected." && exit 0

  remove_package "$file" "$pkg"
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
