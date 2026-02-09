#!/usr/bin/env dash
set -eu

# ============================================================================
# Configuration
# ============================================================================

# Command aliases
CMD_ADD="a"
CMD_ADD_FULL="add"
CMD_REMOVE="r"
CMD_REMOVE_FULL="remove"
CMD_NIX="n"
CMD_NIX_FULL="nix"
CMD_FLATPAK="f"
CMD_FLATPAK_FULL="flatpak"
CMD_STABLE="s"
CMD_STABLE_FULL="stable"

# Nix package configuration
NIX_PKG_PREFIX="pkgs"
NIX_CONFIG_FILENAME="pkgs.nix"
NIX_STABLE_PKG_PREFIX="pkgs.stable"
NIX_STABLE_CONFIG_FILENAME="pkgs-stable.nix"
USE_STABLE=false

# Flatpak configuration
FLATPAK_CONFIG_FILENAME="flatpak.nix"

DEFAULT_DIR="${HOME}/nix-config"
BACKUP_DIR="${XDG_STATE_HOME}/npp-backups"
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
msg_info() { printf "%b%s%b %s\n" "${GREEN}" "✓" "${NC}" "$1" >&2; }
msg_warn() { printf "%b%s%b %s\n" "${YELLOW}" "⚠" "${NC}" "$1" >&2; }
msg_error() { printf "%b%s%b %s\n" "${RED}" "✗" "${NC}" "$1" >&2; }

# ============================================================================
# Confirm + Diff + Apply
# ============================================================================
confirm_and_apply() {
  original="$1"
  temp="$2"

  # Empty check
  if [ ! -s "$temp" ]; then
    msg_error "Generated file is EMPTY. Aborting."
    rm -f "$temp"
    exit 1
  fi

  # Syntax check with debug
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

  printf "%b%s%b\n" "${YELLOW}" "--- DIFF ---" "${NC}"
  # Avoid exit on non-zero diff exit code
  diff -u "$original" "$temp" | awk -v g="$GREEN" -v r="$RED" -v n="$NC" '
        /^@@/     { print $0; next }
        /^\+\+\+/ { print $0; next }
        /^---/    { print $0; next }
        /^\+/     { print g $0 n; next }
        /^-/      { print r $0 n; next }
        { print }
    ' || true
  printf "%b%s%b\n" "${YELLOW}" "-------------" "${NC}"

  # Read from tty for user input
  printf "Apply changes? [Y/n] "
  read -r answer </dev/tty
  
  case "${answer:-}" in
    [Yy]*|"")
      mkdir -p "$BACKUP_DIR"

      timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
      base="$(basename "$original")"
      backup_name="${base}.${timestamp}.backup"
      backup_path="$BACKUP_DIR/$backup_name"

      # Save backup
      cp "$original" "$backup_path"

      # Enforce backup retention per file (keep newest MAX_BACKUPS)
      if [ -n "${MAX_BACKUPS:-}" ]; then
        # Use find/sort/head to get old backups instead of arrays
        find "$BACKUP_DIR" -maxdepth 1 -name "${base}.*.backup" -printf "%T@ %p\n" | \
          sort -rn | tail -n +$((MAX_BACKUPS + 1)) | cut -d' ' -f2- | \
          while read -r old_backup; do
            rm -f "$old_backup"
          done
      fi

      mv "$temp" "$original"
      msg_info "Changes applied. Backup saved at: $backup_path"
      ;;
    *)
      msg_warn "Aborted. No changes applied."
      rm -f "$temp"
      exit 0
      ;;
  esac
}

# ============================================================================
# Flake Root Detection + Config File Discovery (recursive)
# ============================================================================
find_flake_root() {
  dir="$PWD"
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
  pattern="$1"
  
  # Find files and count them using wc -l
  matches_file=$(mktemp)
  find "$CONFIG_DIR" -type f -name "$pattern" > "$matches_file"
  
  count=$(wc -l < "$matches_file")
  
  if [ "$count" -eq 0 ]; then
    echo ""
    rm -f "$matches_file"
    return
  fi

  if [ "$count" -gt 1 ]; then
    msg_error "Multiple '$pattern' files found under flake root:"
    while read -r match; do
      printf " - %s\n" "$match"
    done < "$matches_file"
    rm -f "$matches_file"
    exit 1
  fi

  head -n 1 "$matches_file"
  rm -f "$matches_file"
}

# Nix config files
NIX_DEFAULT_CONFIG="$(find_single_file "$NIX_CONFIG_FILENAME")"
NIX_DEFAULT_CONFIG_STABLE="$(find_single_file "$NIX_STABLE_CONFIG_FILENAME")"

# Flatpak config file
FLATPAK_DEFAULT_CONFIG="$(find_single_file "$FLATPAK_CONFIG_FILENAME")"

# ============================================================================
# Validation
# ============================================================================
check_nix_dependencies() {
  missing=""
  command -v fzf >/dev/null || missing="$missing fzf"
  command -v nix-search-tv >/dev/null || missing="$missing nix-search-tv"
  command -v nix-instantiate >/dev/null || missing="$missing nix-instantiate"

  if [ -n "$missing" ]; then
    msg_error "Missing dependencies:$missing"
    exit 1
  fi
}

check_flatpak_dependencies() {
  missing=""
  command -v fzf >/dev/null || missing="$missing fzf"
  command -v flatpak >/dev/null || missing="$missing flatpak"
  command -v nix-instantiate >/dev/null || missing="$missing nix-instantiate"

  if [ -n "$missing" ]; then
    msg_error "Missing dependencies:$missing"
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

resolve_nix_config_file() {
  file="$1"
  if [ -z "${file:-}" ]; then
    if [ "$USE_STABLE" = true ] && [ -n "$NIX_DEFAULT_CONFIG_STABLE" ]; then
      echo "$NIX_DEFAULT_CONFIG_STABLE"
    else
      echo "$NIX_DEFAULT_CONFIG"
    fi
  else
    echo "$file"
  fi
}

# ============================================================================
# Nix Package Functions
# ============================================================================

get_nix_package_name() {
  echo "$1" | sed "s/^${NIX_PKG_PREFIX}\.//"
}

extract_nix_packages() {
  file="$1"

  awk -v stable_prefix="$NIX_STABLE_PKG_PREFIX" '
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
        gsub("^" stable_prefix "\\.", "", pkg)
        gsub(/[ \t].*$/, "", pkg)
        if (pkg != "") print pkg
        next
    }
    ' "$file"
}

select_nix_package_to_add() {
  # fzf UI with multi-select (Tab to select, Enter to confirm)
  # We use --print-query to capture input if the user wants to add a custom package not in the list.
  
  fzf_output=$(
    {
      nix-search-tv print nixpkgs
      nix-search-tv print nur
    } |
      grep -E "^nixpkgs/|^nur/" |
      sort -u |
      fzf \
        --print-query \
        --prompt='Search nixpkgs package (Tab=select, Enter=confirm) > ' \
        --preview 'nix-search-tv preview {}' \
        --border --reverse --ansi \
        --exact \
        --multi \
        --bind 'tab:toggle+down' \
        --tiebreak=begin,length
  ) || fzf_exit_code=$?

  # Exit code 130 means user cancelled (Esc/Ctrl-C)
  if [ "${fzf_exit_code:-0}" -eq 130 ]; then
    return 1
  fi

  [ -z "$fzf_output" ] && return 1

  # The first line is the query
  query="$(echo "$fzf_output" | head -n1)"
  # The rest are the selections, skip first line (query)
  selected_lines="$(echo "$fzf_output" | tail -n +2)"

  # If nothing selected, but query exists, use query as the package
  if [ -z "$selected_lines" ]; then
    if [ -n "$query" ]; then
      # Assume the user typed the exact package name
      echo "$query"
      return 0
    fi
    return 1
  fi

  # Process each selected line
  printf "%s\n" "$selected_lines" | while IFS= read -r selected; do
    [ -z "$selected" ] && continue
    
    # Extract first token-like part (before tab or pipe)
    # Using cut or awk because string manipulation in dash is limited
    raw=$(echo "$selected" | cut -f1 | cut -d'|' -f1)

    # --- Attribute Path Normalization ---
    # 1. Remove all spaces
    raw=$(echo "$raw" | tr -d '[:space:]')

    # 2. Convert slashes (path format) to dots (Nix attribute format)
    clean=$(echo "$raw" | tr '/' '.')

    # 3. Strip the standard nixpkgs. prefix if present
    clean="${clean#nixpkgs.}"

    pkg="$clean"

    # --- Generic Prefix Deduplication ---
    first_segment="${pkg%%.*}"

    case "$pkg" in
      "$first_segment.$first_segment."*)
        pkg="${pkg#$first_segment.}"
        ;;
    esac

    if [ -n "$pkg" ]; then
      echo "$pkg"
    fi
  done
}

select_nix_package_to_remove() {
  file="$1"

  extract_nix_packages "$file" |
    fzf \
      --prompt='Select package to remove > ' \
      --border --reverse --ansi \
      --exact \
      --tiebreak=begin,length
}

add_nix_package() {
  file="$1"
  attr="$2"

  if ! grep -q "environment\.systemPackages" "$file"; then
    msg_error "systemPackages block missing — abort."
    exit 1
  fi

  bare="$(get_nix_package_name "$attr")"

  # crude duplicate guard (by bare name)
  # using grep with word boundaries
  if grep -q "[[:<:]]$bare[[:>:]]" "$file" 2>/dev/null || grep -q "\b$bare\b" "$file"; then
    msg_warn "Already exists: $bare"
    exit 0
  fi

  prefItem="$NIX_PKG_PREFIX.$bare"
  temp="$(mktemp)"

  awk -v bare="$bare" -v prefItem="$prefItem" -v stable_prefix="$NIX_STABLE_PKG_PREFIX" '
        BEGIN { in_env=0; in_list=0; inserted=0; use_bare=0 }

        /environment\.systemPackages/ {
            in_env=1
            pat_stable = "with[ \\t]+" stable_prefix "[ \\t]*;"
            if ($0 ~ /with[ \t]+pkgs[ \t]*;/ || $0 ~ pat_stable) {
                use_bare=1
            }
            print
            if (index($0, "[") > 0) {
                in_list=1
            }
            next
        }

        in_env && !in_list && index($0, "[") == 0 {
            pat_stable = "with[ \\t]+" stable_prefix "[ \\t]*;"
            if ($0 ~ /with[ \t]+pkgs[ \t]*;/ || $0 ~ pat_stable) {
                use_bare=1
            }
            print
            next
        }

        in_env && !in_list && index($0, "[") > 0 {
            pat_stable = "with[ \\t]+" stable_prefix "[ \\t]*;"
            if ($0 ~ /with[ \t]+pkgs[ \t]*;/ || $0 ~ pat_stable) {
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
                gsub("^" stable_prefix "\\.", "", cur)
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

remove_nix_package() {
  file="$1"
  pkg="$2"

  if ! grep -q "environment\.systemPackages" "$file"; then
    msg_error "systemPackages block missing — abort."
    exit 1
  fi

  temp="$(mktemp)"

  awk -v target="$pkg" -v stable_prefix="$NIX_STABLE_PKG_PREFIX" '
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
                gsub("^" stable_prefix "\\.", "", cur)
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
# Flatpak Package Functions
# ============================================================================

extract_flatpak_packages() {
  file="$1"

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

select_flatpak_to_add() {
  selected=""
  app_id=""

  # Use flatpak search and format output for fzf
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
  app_id="$(echo "$app_id" | tr -d '[:space:]')"

  if [ -z "$app_id" ]; then
    msg_error "Invalid selection: '$selected' → parsed empty application ID"
    return 1
  fi

  echo "$app_id"
}

select_flatpak_to_remove() {
  file="$1"

  extract_flatpak_packages "$file" |
    fzf \
      --prompt='Select Flatpak to remove > ' \
      --border --reverse --ansi \
      --exact \
      --tiebreak=begin,length
}

add_flatpak_package() {
  file="$1"
  app_id="$2"

  if ! grep -qE "services\.flatpak\.packages|packages[[:space:]]*=" "$file"; then
    msg_error "services.flatpak.packages block missing — abort."
    exit 1
  fi

  # Check if already exists
  if grep -q "\"$app_id\"" "$file"; then
    msg_warn "Already exists: $app_id"
    exit 0
  fi

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

remove_flatpak_package() {
  file="$1"
  pkg="$2"

  if ! grep -qE "services\.flatpak\.packages|packages[[:space:]]*=" "$file"; then
    msg_error "services.flatpak.packages block missing — abort."
    exit 1
  fi

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
  printf "%b%s%b — Nix Package Provider\n\n" "${BOLD}" "npp" "${NC}"
  echo "Usage:"
  echo "  npp $CMD_NIX $CMD_ADD    [$CMD_STABLE] [FILE]   Add nixpkgs package(s) (multi-select with Tab)"
  echo "  npp $CMD_NIX $CMD_REMOVE [$CMD_STABLE] [FILE]   Remove a nixpkgs package"
  echo "  npp $CMD_NIX $CMD_STABLE $CMD_ADD  [FILE]       Add stable nixpkgs package(s)"
  echo "  npp $CMD_NIX $CMD_STABLE $CMD_REMOVE [FILE]     Remove a stable nixpkgs package"
  echo ""
  echo "  npp $CMD_FLATPAK $CMD_ADD    [FILE]             Add a Flatpak package"
  echo "  npp $CMD_FLATPAK $CMD_REMOVE [FILE]             Remove a Flatpak package"
  echo ""
  echo "Aliases:"
  echo "  $CMD_NIX/$CMD_NIX_FULL = nix packages (unstable)"
  echo "  $CMD_NIX $CMD_STABLE/$CMD_STABLE_FULL = nix packages (stable)"
  echo "  $CMD_FLATPAK/$CMD_FLATPAK_FULL = flatpak packages"
  echo "  $CMD_ADD/$CMD_ADD_FULL = add package"
  echo "  $CMD_REMOVE/$CMD_REMOVE_FULL = remove package"
}

# ============================================================================
# Nix Commands
# ============================================================================
nix_cmd_add() {
  file=""
  NIX_PKG_PREFIX="pkgs"

  while [ $# -gt 0 ]; do
    case "$1" in
    "$CMD_STABLE" | "$CMD_STABLE_FULL")
      USE_STABLE=true
      NIX_PKG_PREFIX="$NIX_STABLE_PKG_PREFIX"
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    *) file="$1" ;;
    esac
    shift
  done

  file="$(resolve_nix_config_file "$file")"

  if [ -z "$file" ]; then
    msg_error "No $NIX_CONFIG_FILENAME found under flake root."
    exit 1
  fi

  check_nix_dependencies
  check_config_file "$file"

  if ! packages="$(select_nix_package_to_add)"; then
    msg_warn "No package selected."
    exit 0
  fi

  # Process each selected package
  # Avoiding use of here-string `<<<` which is a bashism
  # Using printf and pipeline instead
  printf "%s\n" "$packages" | while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    full_attr="${NIX_PKG_PREFIX}.${pkg}"
    add_nix_package "$file" "$full_attr"
  done
}

nix_cmd_remove() {
  file=""
  NIX_PKG_PREFIX="pkgs"
  
  while [ $# -gt 0 ]; do
    case "$1" in
    "$CMD_STABLE" | "$CMD_STABLE_FULL")
      USE_STABLE=true
      NIX_PKG_PREFIX="$NIX_STABLE_PKG_PREFIX"
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    *) file="$1" ;;
    esac
    shift
  done

  file="$(resolve_nix_config_file "$file")"

  if [ -z "$file" ]; then 
    msg_error "No $NIX_CONFIG_FILENAME found under flake root."
    exit 1
  fi

  check_nix_dependencies
  check_config_file "$file"

  pkg="$(select_nix_package_to_remove "$file" || true)"
  if [ -z "$pkg" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  remove_nix_package "$file" "$pkg"
}

# ============================================================================
# Flatpak Commands
# ============================================================================
flatpak_cmd_add() {
  file=""

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
    file="$FLATPAK_DEFAULT_CONFIG"
  fi

  if [ -z "$file" ]; then
    msg_error "No $FLATPAK_CONFIG_FILENAME found under flake root."
    exit 1
  fi

  check_flatpak_dependencies
  check_config_file "$file"

  if ! app_id="$(select_flatpak_to_add)"; then
    msg_warn "No flatpak selected."
    exit 0
  fi
  add_flatpak_package "$file" "$app_id"
}

flatpak_cmd_remove() {
  file=""

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
    file="$FLATPAK_DEFAULT_CONFIG"
  fi

  if [ -z "$file" ]; then
    msg_error "No $FLATPAK_CONFIG_FILENAME found under flake root."
    exit 1
  fi

  check_flatpak_dependencies
  check_config_file "$file"

  pkg="$(select_flatpak_to_remove "$file" || true)"
  if [ -z "$pkg" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  remove_flatpak_package "$file" "$pkg"
}

# ============================================================================
# Main Entry Point
# ============================================================================
main() {
  if [ $# -eq 0 ]; then
    show_usage
    exit 1
  fi

  case "$1" in
  "$CMD_NIX" | "$CMD_NIX_FULL")
    shift
    if [ $# -eq 0 ]; then
      msg_error "Missing subcommand for '$CMD_NIX'. Use: $CMD_ADD, $CMD_REMOVE, or $CMD_STABLE"
      exit 1
    fi

    case "$1" in
    "$CMD_STABLE" | "$CMD_STABLE_FULL")
      shift
      USE_STABLE=true
      NIX_PKG_PREFIX="$NIX_STABLE_PKG_PREFIX"
      if [ $# -eq 0 ]; then
        msg_error "Missing subcommand for '$CMD_NIX $CMD_STABLE'. Use: $CMD_ADD or $CMD_REMOVE"
        exit 1
      fi

      case "$1" in
      "$CMD_ADD" | "$CMD_ADD_FULL")
        shift
        nix_cmd_add "$@"
        ;;
      "$CMD_REMOVE" | "$CMD_REMOVE_FULL")
        shift
        nix_cmd_remove "$@"
        ;;
      *)
        msg_error "Unknown subcommand: $1"
        exit 1
        ;;
      esac
      ;;
    "$CMD_ADD" | "$CMD_ADD_FULL")
      shift
      nix_cmd_add "$@"
      ;;
    "$CMD_REMOVE" | "$CMD_REMOVE_FULL")
      shift
      nix_cmd_remove "$@"
      ;;
    *)
      msg_error "Unknown subcommand: $1"
      exit 1
      ;;
    esac
    ;;
  "$CMD_FLATPAK" | "$CMD_FLATPAK_FULL")
    shift
    if [ $# -eq 0 ]; then
      msg_error "Missing subcommand for '$CMD_FLATPAK'. Use: $CMD_ADD or $CMD_REMOVE"
      exit 1
    fi

    case "$1" in
    "$CMD_ADD" | "$CMD_ADD_FULL")
      shift
      flatpak_cmd_add "$@"
      ;;
    "$CMD_REMOVE" | "$CMD_REMOVE_FULL")
      shift
      flatpak_cmd_remove "$@"
      ;;
    *)
      msg_error "Unknown subcommand: $1"
      exit 1
      ;;
    esac
    ;;
  -h | --help)
    show_usage
    ;;
  *)
    msg_error "Unknown command: $1"
    show_usage
    exit 1
    ;;
  esac
}

main "$@"
