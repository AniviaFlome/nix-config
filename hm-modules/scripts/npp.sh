#!/usr/bin/env dash
# npp — Nix Package Provider
# Add/remove nixpkgs (unstable + stable) and Flatpak packages from this flake.
#
#   npp n a [s] [FILE]   add nixpkgs package(s), Tab = multi-select
#   npp n r [s] [FILE]   remove nixpkgs package(s), Tab = multi-select
#   npp f a [FILE]       add a Flatpak package (prompts for origin)
#   npp f r [FILE]       remove Flatpak package(s), Tab = multi-select
#
# Global flags: -y / --yes (skip confirm), -h / --help.
# Env: NPP_FLAKE_ROOT overrides flake-root detection, NO_COLOR disables color.

set -eu

# ============================================================================
# Configuration
# ============================================================================
DEFAULT_DIR="${HOME}/nix-config"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/npp-backups"
MAX_BACKUPS=14

ASSUME_YES=false

NIX_UNSTABLE_PREFIX="pkgs"
NIX_STABLE_PREFIX="pkgs.stable"
NIX_UNSTABLE_FILE="pkgs.nix"
NIX_STABLE_FILE="pkgs-stable.nix"
FLATPAK_FILE="flatpak.nix"

# ============================================================================
# Colors (tty + NO_COLOR aware)
# ============================================================================
if [ "${NO_COLOR:-}" != "" ] || [ ! -t 2 ]; then
  BOLD=""
  GREEN=""
  YELLOW=""
  RED=""
  NC=""
else
  BOLD='\033[1m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  NC='\033[0m'
fi

# ============================================================================
# Basics
# ============================================================================
msg_info() { printf "%b%s%b %s\n" "${GREEN}" "✓" "${NC}" "${1:-}" >&2; }
msg_warn() { printf "%b%s%b %s\n" "${YELLOW}" "⚠" "${NC}" "${1:-}" >&2; }
msg_error() { printf "%b%s%b %s\n" "${RED}" "✗" "${NC}" "${1:-}" >&2; }

die() {
  msg_error "${1:-fatal}"
  exit "${2:-1}"
}

need_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    die "Missing required command: $cmd"
  fi
}

# True when we can interactively prompt (subshell keeps dash's own
# redirection error off stderr when there is no controlling terminal).
have_tty() { (: </dev/tty) 2>/dev/null; }

# ============================================================================
# Confirm + Diff + Apply
# ============================================================================
confirm_and_apply() {
  local original="$1" temp="$2" parse_log failed diff_out answer timestamp base backup_path

  if [ ! -s "$temp" ]; then
    msg_error "Generated file is EMPTY. Aborting."
    rm -f "$temp"
    exit 1
  fi

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

  if cmp -s "$original" "$temp"; then
    msg_info "No changes."
    rm -f "$temp"
    return 0
  fi

  printf "%b%s%b\n" "${YELLOW}" "--- DIFF ---" "${NC}"
  diff_out="$(diff -u "$original" "$temp" || true)"
  printf "%s\n" "$diff_out" | awk -v g="$GREEN" -v r="$RED" -v n="$NC" '
    /^@@/     { print $0; next }
    /^\+\+\+/ { print $0; next }
    /^---/    { print $0; next }
    /^\+/     { print g $0 n; next }
    /^-/      { print r $0 n; next }
    { print }
  ' || true
  printf "%b%s%b\n" "${YELLOW}" "-------------" "${NC}"

  if [ "$ASSUME_YES" = true ]; then
    answer="y"
  else
    if ! have_tty; then
      msg_error "No tty for confirmation. Re-run with -y/--yes."
      rm -f "$temp"
      exit 1
    fi
    printf "Apply changes? [Y/n] "
    read -r answer </dev/tty 2>/dev/null || answer="n"
  fi

  case "${answer:-}" in
  [Yy]* | "")
    mkdir -p "$BACKUP_DIR"
    timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
    base="$(basename "$original")"
    backup_path="$BACKUP_DIR/${base}.${timestamp}.backup"
    cp "$original" "$backup_path"
    # Keep newest MAX_BACKUPS per file.
    find "$BACKUP_DIR" -maxdepth 1 -name "${base}.*.backup" -printf "%T@ %p\n" |
      sort -rn | tail -n +"$((MAX_BACKUPS + 1))" | cut -d' ' -f2- |
      while IFS= read -r old_backup; do
        [ -n "$old_backup" ] && rm -f "$old_backup"
      done
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
# Flake root + config discovery (lazy, per command)
# ============================================================================
find_flake_root() {
  local dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/flake.nix" ]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

resolve_root() {
  local root=""
  if [ -n "${NPP_FLAKE_ROOT:-}" ] && [ -d "$NPP_FLAKE_ROOT" ]; then
    echo "$NPP_FLAKE_ROOT"
    return 0
  fi
  if root="$(find_flake_root 2>/dev/null)"; then
    echo "$root"
    return 0
  fi
  if [ -n "${DEFAULT_DIR:-}" ] && [ -d "$DEFAULT_DIR" ]; then
    echo "$DEFAULT_DIR"
    return 0
  fi
  msg_error "flake.nix not found in parent paths and $DEFAULT_DIR is missing."
  msg_error "Set NPP_FLAKE_ROOT or pass FILE explicitly."
  exit 1
}

find_one() {
  local root="$1" pat="$2" res n
  res="$(find "$root" -path "$root/.git" -prune -o -type f -name "$pat" -print 2>/dev/null | sort || true)"
  if [ -z "$res" ]; then
    echo ""
    return 0
  fi
  n="$(printf "%s\n" "$res" | grep -c . || true)"
  if [ "$n" -gt 1 ]; then
    msg_error "Multiple '$pat' files found under $root:"
    printf "%s\n" "$res" | while IFS= read -r m; do printf " - %s\n" "$m" >&2; done
    exit 1
  fi
  printf "%s\n" "$res"
}

resolve_nix_file() {
  local explicit="${1:-}" stable="${2:-false}" root fname
  if [ -n "$explicit" ]; then
    echo "$explicit"
    return 0
  fi
  root="$(resolve_root)"
  if [ "$stable" = true ]; then
    fname="$NIX_STABLE_FILE"
  else
    fname="$NIX_UNSTABLE_FILE"
  fi
  find_one "$root" "$fname"
}

resolve_flatpak_file() {
  local explicit="${1:-}" root
  if [ -n "$explicit" ]; then
    echo "$explicit"
    return 0
  fi
  root="$(resolve_root)"
  find_one "$root" "$FLATPAK_FILE"
}

check_config_file() {
  local file="${1:-}"
  if [ -z "$file" ] || [ ! -f "$file" ]; then
    die "Config file not found: ${file:-<empty>}"
  fi
  if [ ! -r "$file" ]; then
    die "Config not readable: $file"
  fi
  if [ ! -w "$file" ]; then
    die "Config not writable: $file"
  fi
}

# ============================================================================
# Nix: extract + batch insert/remove
# ============================================================================
extract_nix_packages() {
  local file="$1"
  awk -v stable_prefix="$NIX_STABLE_PREFIX" '
    function bare(s,   p, rx) {
      p = s
      sub(/#.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      sub(/;.*$/, "", p)
      rx = "^" stable_prefix "\\."
      if (p ~ rx) sub(rx, "", p)
      else sub(/^pkgs\./, "", p)
      sub(/;.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      return p
    }
    /environment\.systemPackages/ { in_env = 1 }
    in_env && !in_list && index($0, "[") > 0 { in_list = 1; next }
    in_env && !in_list { next }
    in_list {
      t = $0
      gsub(/^[ \t]+/, "", t)
      gsub(/[ \t]+$/, "", t)
      if (t ~ /^\]/) exit
      if (t == "" || t ~ /^#/ || index(t, "[") > 0) next
      b = bare($0)
      if (b != "") print b
    }
  ' "$file"
}

# nix_insert_batch src addfile prefix  — stdout is the new file content.
nix_insert_batch() {
  local src="$1" addfile="$2" prefix="$3"
  awk -v stable_prefix="$NIX_STABLE_PREFIX" -v prefix="$prefix" -v addfile="$addfile" '
    function bare(s,   p, rx) {
      p = s
      sub(/#.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      sub(/;.*$/, "", p)
      rx = "^" stable_prefix "\\."
      if (p ~ rx) sub(rx, "", p)
      else sub(/^pkgs\./, "", p)
      sub(/;.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      return p
    }
    function emit(b,   it) {
      if (indent == "") indent = "    "
      it = (use_bare ? b : prefix "." b)
      print indent it
    }
    BEGIN {
      n = 0
      while ((getline l < addfile) > 0) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", l)
        if (l != "") want[++n] = l
      }
      close(addfile)
      wi = 1; in_env = 0; in_list = 0; use_bare = 0; indent = ""
    }
    /environment\.systemPackages/ {
      in_env = 1
      if ($0 ~ /with[ \t]+pkgs\.stable[ \t]*;/ || $0 ~ /with[ \t]+pkgs[ \t]*;/) use_bare = 1
      print
      if (index($0, "[") > 0) in_list = 1
      next
    }
    in_env && !in_list {
      if ($0 ~ /with[ \t]+pkgs\.stable[ \t]*;/ || $0 ~ /with[ \t]+pkgs[ \t]*;/) use_bare = 1
      print
      if (index($0, "[") > 0) in_list = 1
      next
    }
    in_list {
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (index(s, "# keep-" "sorted end") > 0) {
        while (wi <= n) { emit(want[wi]); wi++ }
        print line; next
      }
      if (s ~ /^\]/) {
        while (wi <= n) { emit(want[wi]); wi++ }
        print line; in_list = 0; in_env = 0; next
      }
      if (s == "" || s ~ /^#/ || index(s, "[") > 0) { print line; next }
      if (indent == "") {
        if (match(line, /^[ \t]+/)) indent = substr(line, RSTART, RLENGTH)
        else indent = "    "
      }
      cur = bare(line)
      while (wi <= n && tolower(want[wi]) < tolower(cur)) { emit(want[wi]); wi++ }
      if (wi <= n && tolower(want[wi]) == tolower(cur)) wi++
      print line; next
    }
    { print }
    END { if (in_list) while (wi <= n) emit(want[wi]) }
  ' "$src"
}

# nix_remove_batch src rmfile — stdout is the new file content.
nix_remove_batch() {
  local src="$1" rmfile="$2"
  awk -v stable_prefix="$NIX_STABLE_PREFIX" -v rmfile="$rmfile" '
    function bare(s,   p, rx) {
      p = s
      sub(/#.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      sub(/;.*$/, "", p)
      rx = "^" stable_prefix "\\."
      if (p ~ rx) sub(rx, "", p)
      else sub(/^pkgs\./, "", p)
      sub(/;.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      return p
    }
    BEGIN {
      while ((getline l < rmfile) > 0) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", l)
        if (l != "") kill[tolower(l)] = 1
      }
      close(rmfile)
      in_env = 0; in_list = 0
    }
    /environment\.systemPackages/ { in_env = 1; print; if (index($0, "[") > 0) in_list = 1; next }
    in_env && !in_list { print; if (index($0, "[") > 0) in_list = 1; next }
    in_list {
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (s ~ /^\]/) { print line; in_list = 0; in_env = 0; next }
      if (s == "" || s ~ /^#/ || index(s, "[") > 0) { print line; next }
      cur = bare(line)
      if (cur != "" && (tolower(cur) in kill)) next
      print line; next
    }
    { print }
  ' "$src"
}

# Normalize fzf selection lines to bare nix attrs (stdin -> stdout).
normalize_nix_attrs() {
  awk '{
    line = $0
    sub(/\t.*$/, "", line)
    sub(/\|.*$/, "", line)
    gsub(/[[:space:]]/, "", line)
    gsub(/\//, ".", line)
    sub(/^nixpkgs\./, "", line)
    if (line == "") next
    n = split(line, parts, ".")
    seg = parts[1]
    pre = seg "."
    if (substr(line, 1, length(pre)) == pre) {
      rest = substr(line, length(pre) + 1)
      if (substr(rest, 1, length(pre)) == pre) line = substr(line, length(pre) + 1)
    }
    if (line != "") print line
  }'
}

pick_nix_add() {
  local stable="${1:-false}" fzf_output="" fzf_code=0 query="" selected_lines=""
  need_cmd fzf
  need_cmd nix-search-tv

  # shellcheck disable=SC2016
  # fzf expands {} at preview time; the $() runs inside fzf, not here.
  fzf_output="$(
    {
      (nix-search-tv print --indexes nixpkgs 2>/dev/null ||
        nix-search-tv print --offline --indexes nixpkgs 2>/dev/null) |
        sed 's|^|nixpkgs/ |'
      (nix-search-tv print --indexes nur 2>/dev/null ||
        nix-search-tv print --offline --indexes nur 2>/dev/null) |
        sed 's|^|nur/ |'
    } |
      grep -E "^(nixpkgs|nur)/[[:space:]]+[[:alnum:]_.+-]+$" |
      sort -u |
      fzf \
        --print-query \
        --prompt='Search Nix package (Tab=select, Enter=confirm) > ' \
        --preview 'nix-search-tv preview --indexes nixpkgs --indexes nur "$(printf "%s" {} | tr -d " " | sed -e "s|^nixpkgs/||" -e "s|^nur/nur\\.|nur.|")"' \
        --delimiter='[[:space:]]+' \
        --freeze-left=1 \
        --border --reverse --ansi \
        --exact \
        --multi \
        --bind 'tab:toggle+down' \
        --tiebreak=begin,length
  )" || fzf_code=$?

  if [ "$fzf_code" -eq 130 ]; then
    return 1
  fi
  if [ "$fzf_code" -ne 0 ] && [ -z "$fzf_output" ]; then
    return 1
  fi
  if [ -z "$fzf_output" ]; then
    return 1
  fi

  query="$(printf "%s\n" "$fzf_output" | head -n1)"
  selected_lines="$(printf "%s\n" "$fzf_output" | tail -n +2)"

  if [ -z "$selected_lines" ]; then
    if [ -n "$query" ]; then
      printf "%s\n" "$query" | normalize_nix_attrs | sort -u
      return 0
    fi
    return 1
  fi

  printf "%s\n" "$selected_lines" | normalize_nix_attrs | sort -u
}

pick_nix_remove() {
  local file="$1"
  need_cmd fzf
  extract_nix_packages "$file" | sort -f -u |
    fzf \
      --prompt='Select package(s) to remove (Tab=multi) > ' \
      --border --reverse --ansi \
      --exact \
      --multi \
      --tiebreak=begin,length
}

# ============================================================================
# Flatpak: extract + insert/remove (flathub strings + {appId, origin} blocks)
# ============================================================================
# Prints: appId<TAB>origin, covering both package blocks.
extract_flatpak_packages() {
  local file="$1"
  awk '
    /^[ \t]*packages[ \t]*=/ { in_pkg = 1; next }
    in_pkg && /^[ \t]*overrides[ \t]*=/ { exit }
    !in_pkg { next }
    {
      if (match($0, /appId[ \t]*=[ \t]*"[^"]+"/)) {
        seg = substr($0, RSTART, RLENGTH)
        a = seg; sub(/^[^"]*"/, "", a); sub(/".*/, "", a)
        if (match($0, /origin[ \t]*=[ \t]*"[^"]+"/)) {
          oseg = substr($0, RSTART, RLENGTH)
          o = oseg; sub(/^[^"]*"/, "", o); sub(/".*/, "", o)
          print a "\t" o; pending = ""
        } else {
          pending = a
        }
        next
      }
      if (pending != "") {
        if (match($0, /origin[ \t]*=[ \t]*"[^"]+"/)) {
          oseg = substr($0, RSTART, RLENGTH)
          o = oseg; sub(/^[^"]*"/, "", o); sub(/".*/, "", o)
          print pending "\t" o; pending = ""; next
        }
        if ($0 ~ /^[ \t]*\}[,;]?[ \t]*$/) { print pending "\tflathub"; pending = ""; next }
      }
      s = $0
      gsub(/^[ \t]+|[ \t]+$/, "", s)
      if (s ~ /^"[^"]+"[ \t,;]*$/) {
        a = s; gsub(/"/, "", a); sub(/[ \t,;]*$/, "", a)
        print a "\tflathub"
      }
    }
  ' "$file"
}

extract_flatpak_remotes() {
  local file="$1"
  awk '
    /^[ \t]*remotes[ \t]*=/ { in_r = 1; next }
    in_r && /^[ \t]*\];/ { exit }
    !in_r { next }
    {
      if (match($0, /name[ \t]*=[ \t]*"[^"]+"/)) {
        seg = substr($0, RSTART, RLENGTH)
        n = seg; sub(/^[^"]*"/, "", n); sub(/".*/, "", n)
        if (n != "") print n
      }
    }
  ' "$file"
}

flatpak_exists() {
  local file="$1" target="$2"
  extract_flatpak_packages "$file" | awk -F'\t' -v t="$target" '
    tolower($1) == tolower(t) { found = 1; exit }
    END { exit !found }
  '
}

# Insert one flathub string, sorted. stdout = new content.
flatpak_insert_string() {
  local src="$1" app_id="$2"
  awk -v app="$app_id" '
    BEGIN { in_pkg = 0; list_no = 0; in_list = 0; target = 0; inserted = 0; indent = "" }
    /^[ \t]*packages[ \t]*=/ { in_pkg = 1; print; next }
    in_pkg && /^[ \t]*overrides[ \t]*=/ { in_pkg = 0; print; next }
    in_pkg && !in_list && index($0, "[") > 0 { list_no++; in_list = 1; target = (list_no == 1); print; next }
    in_list && !target {
      t = $0; gsub(/^[ \t]+|[ \t]+$/, "", t)
      if (t ~ /^\]/) in_list = 0
      print; next
    }
    in_list && target {
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (index(s, "# keep-" "sorted end") > 0) {
        if (!inserted) { if (indent == "") indent = "        "; printf "%s\"%s\"\n", indent, app; inserted = 1 }
        print line; next
      }
      if (s ~ /^\]/) {
        if (!inserted) { if (indent == "") indent = "        "; printf "%s\"%s\"\n", indent, app; inserted = 1 }
        print line; in_list = 0; next
      }
      if (s == "" || s ~ /^#/ || index(s, "[") > 0 || s ~ /^\{/) { print line; next }
      if (indent == "" && s ~ /^"/) {
        if (match(line, /^[ \t]+/)) indent = substr(line, RSTART, RLENGTH)
        else indent = "        "
      }
      if (!inserted && s ~ /^"/) {
        cur = s; gsub(/"/, "", cur); sub(/[ \t,;]*$/, "", cur)
        if (tolower(app) < tolower(cur)) { printf "%s\"%s\"\n", indent, app; inserted = 1 }
      }
      print line; next
    }
    { print }
  ' "$src"
}

# Insert one {appId, origin} block, sorted by appId. stdout = new content.
flatpak_insert_block() {
  local src="$1" app_id="$2" origin="$3"
  awk -v app="$app_id" -v origin="$origin" '
    function emit_new() {
      if (oi == "") oi = "        "
      if (fi == "") fi = "          "
      printf "%s{\n%sappId = \"%s\";\n%sorigin = \"%s\";\n%s}\n", oi, fi, app, fi, origin, oi
    }
    BEGIN { in_pkg = 0; list_no = 0; in_list = 0; target = 0; inserted = 0; in_block = 0; buf = ""; oi = ""; fi = "" }
    /^[ \t]*packages[ \t]*=/ { in_pkg = 1; print; next }
    in_pkg && /^[ \t]*overrides[ \t]*=/ { in_pkg = 0; print; next }
    in_pkg && !in_list && index($0, "[") > 0 { list_no++; in_list = 1; target = (list_no >= 2); print; next }
    in_list && !target {
      t = $0; gsub(/^[ \t]+|[ \t]+$/, "", t)
      if (t ~ /^\]/) in_list = 0
      print; next
    }
    in_list && target && in_block {
      buf = buf $0 "\n"
      t = $0; gsub(/^[ \t]+|[ \t]+$/, "", t)
      if (t ~ /^\}[,;]?/) {
        in_block = 0
        existing = ""
        n = split(buf, bl, "\n")
        for (i = 1; i <= n; i++) {
          if (match(bl[i], /appId[ \t]*=[ \t]*"[^"]+"/)) {
            e = substr(bl[i], RSTART, RLENGTH); sub(/^[^"]*"/, "", e); sub(/".*/, "", e); existing = e; break
          }
        }
        if (oi == "") {
          if (match(bl[1], /^[ \t]+/)) oi = substr(bl[1], RSTART, RLENGTH); else oi = "        "
          for (i = 1; i <= n; i++) {
            if (bl[i] ~ /appId/) {
              if (match(bl[i], /^[ \t]+/)) fi = substr(bl[i], RSTART, RLENGTH)
              break
            }
          }
          if (fi == "") fi = "          "
        }
        if (!inserted && existing != "" && tolower(app) < tolower(existing)) { emit_new(); inserted = 1 }
        printf "%s", buf; buf = ""
      }
      next
    }
    in_list && target {
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (s ~ /^\]/) {
        if (!inserted) { emit_new(); inserted = 1 }
        print line; in_list = 0; next
      }
      if (s == "" || s ~ /^#/) { print line; next }
      if (s ~ /^\{/) {
        if (s ~ /\}/) {
          existing = ""
          if (match(line, /appId[ \t]*=[ \t]*"[^"]+"/)) {
            e = substr(line, RSTART, RLENGTH); sub(/^[^"]*"/, "", e); sub(/".*/, "", e); existing = e
          }
          if (oi == "") {
            if (match(line, /^[ \t]+/)) oi = substr(line, RSTART, RLENGTH); else oi = "        "
            fi = oi "  "
          }
          if (!inserted && existing != "" && tolower(app) < tolower(existing)) { emit_new(); inserted = 1 }
          print line; next
        }
        in_block = 1; buf = line "\n"
        if (oi == "") {
          if (match(line, /^[ \t]+/)) oi = substr(line, RSTART, RLENGTH); else oi = "        "
        }
        next
      }
      print line; next
    }
    { print }
  ' "$src"
}

# flatpak_remove_batch src rmfile — stdout is the new content.
flatpak_remove_batch() {
  local src="$1" rmfile="$2"
  awk -v rmfile="$rmfile" '
    BEGIN {
      while ((getline l < rmfile) > 0) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", l)
        if (l != "") kill[tolower(l)] = 1
      }
      close(rmfile)
      in_pkg = 0; in_list = 0; in_block = 0; buf = ""
    }
    /^[ \t]*packages[ \t]*=/ { in_pkg = 1; print; next }
    in_pkg && /^[ \t]*overrides[ \t]*=/ { in_pkg = 0; print; next }
    in_pkg && !in_list && index($0, "[") > 0 { in_list = 1; print; next }
    in_list && in_block {
      buf = buf $0 "\n"
      t = $0; gsub(/^[ \t]+|[ \t]+$/, "", t)
      if (t ~ /^\}[,;]?/) {
        in_block = 0
        existing = ""
        n = split(buf, bl, "\n")
        for (i = 1; i <= n; i++) {
          if (match(bl[i], /appId[ \t]*=[ \t]*"[^"]+"/)) {
            e = substr(bl[i], RSTART, RLENGTH); sub(/^[^"]*"/, "", e); sub(/".*/, "", e); existing = e; break
          }
        }
        if (!(existing != "" && (tolower(existing) in kill))) printf "%s", buf
        buf = ""
      }
      next
    }
    in_list {
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (s ~ /^\]/) { print line; in_list = 0; next }
      if (s == "" || s ~ /^#/ || index(s, "[") > 0) { print line; next }
      if (s ~ /^\{/) {
        if (s ~ /\}/) {
          existing = ""
          if (match(line, /appId[ \t]*=[ \t]*"[^"]+"/)) {
            e = substr(line, RSTART, RLENGTH); sub(/^[^"]*"/, "", e); sub(/".*/, "", e); existing = e
          }
          if (existing != "" && (tolower(existing) in kill)) next
          print line; next
        }
        in_block = 1; buf = line "\n"; next
      }
      if (s ~ /^"/) {
        cur = s; gsub(/"/, "", cur); sub(/[ \t,;]*$/, "", cur)
        if (tolower(cur) in kill) next
        print line; next
      }
      print line; next
    }
    { print }
  ' "$src"
}

pick_flatpak_add() {
  local selected="" app_id=""
  need_cmd fzf
  need_cmd flatpak

  selected="$(flatpak search "" --columns=application,name,description |
    awk -F'\t' '{printf "%s | %s - %s\n", $1, $2, $3}' |
    fzf --prompt='Search Flatpak > ' \
      --border --reverse --ansi \
      --exact \
      --tiebreak=begin,length \
      --with-nth=2.. \
      --delimiter='\|')" || return 1

  if [ -z "$selected" ]; then
    return 1
  fi

  app_id="${selected%%|*}"
  app_id="$(printf "%s" "$app_id" | tr -d '[:space:]')"

  if [ -z "$app_id" ]; then
    msg_error "Invalid selection: parsed empty application ID"
    return 1
  fi
  case "$app_id" in
  *.*) ;;
  *)
    msg_error "Invalid application ID: $app_id"
    return 1
    ;;
  esac
  case "$app_id" in
  *[!A-Za-z0-9_.-]*)
    msg_error "Invalid application ID: $app_id"
    return 1
    ;;
  esac

  echo "$app_id"
}

pick_flatpak_remove() {
  local file="$1"
  need_cmd fzf
  extract_flatpak_packages "$file" | sort -f |
    awk -F'\t' '{printf "%s (%s)\n", $1, $2}' |
    fzf \
      --prompt='Select Flatpak(s) to remove (Tab=multi) > ' \
      --border --reverse --ansi \
      --exact \
      --multi \
      --tiebreak=begin,length |
    awk '{ sub(/ \([^(]*\)$/, "", $0); print $0 }'
}

choose_flatpak_origin() {
  local file="$1" preset="${2:-}" remotes="" def="flathub" ans=""
  if [ -n "$preset" ]; then
    echo "$preset"
    return 0
  fi
  remotes="$(extract_flatpak_remotes "$file" || true)"
  if [ -z "$remotes" ]; then
    echo "$def"
    return 0
  fi
  if ! have_tty; then
    echo "$def"
    return 0
  fi
  echo "Available remotes:" >&2
  printf "%s\n" "$remotes" | while IFS= read -r r; do printf " - %s\n" "$r" >&2; done
  printf "Origin [%s]: " "$def" >&2
  read -r ans </dev/tty 2>/dev/null || ans=""
  if [ -z "$ans" ]; then
    echo "$def"
  else
    echo "$ans"
  fi
}

# ============================================================================
# Commands
# ============================================================================
cmd_nix_add() {
  local stable=false file="" prefix picks tmp_new tmp_exist tmp_add tmp_out p
  while [ $# -gt 0 ]; do
    case "$1" in
    s | stable) stable=true ;;
    -y | --yes) ASSUME_YES=true ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      if [ $# -gt 0 ]; then
        file="$1"
        shift
      fi
      break
      ;;
    -*) die "Unknown option: $1" ;;
    *) if [ -z "$file" ]; then file="$1"; else die "Too many files: $1"; fi ;;
    esac
    shift
  done

  if [ "$stable" = true ]; then prefix="$NIX_STABLE_PREFIX"; else prefix="$NIX_UNSTABLE_PREFIX"; fi
  file="$(resolve_nix_file "$file" "$stable")"
  if [ -z "$file" ]; then
    if [ "$stable" = true ]; then
      die "No $NIX_STABLE_FILE found under flake root."
    else die "No $NIX_UNSTABLE_FILE found under flake root."; fi
  fi
  check_config_file "$file"
  if ! grep -q "environment\.systemPackages" "$file"; then
    die "systemPackages block missing in $file — abort."
  fi

  if ! picks="$(pick_nix_add "$stable")"; then
    msg_warn "No package selected."
    exit 0
  fi
  if [ -z "$picks" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  if [ "$stable" = true ]; then
    if printf "%s\n" "$picks" | grep -q "^nur\."; then
      die "NUR packages cannot go into $NIX_STABLE_FILE (pkgs.stable has no NUR scope)."
    fi
  fi

  tmp_new="$(mktemp)"
  tmp_exist="$(mktemp)"
  tmp_add="$(mktemp)"
  printf "%s\n" "$picks" | sort -f -u >"$tmp_new"
  extract_nix_packages "$file" | sort -f -u >"$tmp_exist" || true
  : >"$tmp_add"
  while IFS= read -r p; do
    if [ -z "$p" ]; then continue; fi
    if grep -qixF "$p" "$tmp_exist" 2>/dev/null; then
      msg_warn "Already exists: $p"
    else
      printf "%s\n" "$p" >>"$tmp_add"
    fi
  done <"$tmp_new"

  if [ ! -s "$tmp_add" ]; then
    rm -f "$tmp_new" "$tmp_exist" "$tmp_add"
    exit 0
  fi

  tmp_out="$(mktemp)"
  nix_insert_batch "$file" "$tmp_add" "$prefix" >"$tmp_out"
  rm -f "$tmp_new" "$tmp_exist" "$tmp_add"
  confirm_and_apply "$file" "$tmp_out"
}

cmd_nix_remove() {
  local stable=false file="" picks tmp_rm tmp_out
  while [ $# -gt 0 ]; do
    case "$1" in
    s | stable) stable=true ;;
    -y | --yes) ASSUME_YES=true ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      if [ $# -gt 0 ]; then
        file="$1"
        shift
      fi
      break
      ;;
    -*) die "Unknown option: $1" ;;
    *) if [ -z "$file" ]; then file="$1"; else die "Too many files: $1"; fi ;;
    esac
    shift
  done

  file="$(resolve_nix_file "$file" "$stable")"
  if [ -z "$file" ]; then
    if [ "$stable" = true ]; then
      die "No $NIX_STABLE_FILE found under flake root."
    else die "No $NIX_UNSTABLE_FILE found under flake root."; fi
  fi
  check_config_file "$file"
  if ! grep -q "environment\.systemPackages" "$file"; then
    die "systemPackages block missing in $file — abort."
  fi

  picks="$(pick_nix_remove "$file" || true)"
  if [ -z "$picks" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  tmp_rm="$(mktemp)"
  printf "%s\n" "$picks" | sort -f -u >"$tmp_rm"
  tmp_out="$(mktemp)"
  nix_remove_batch "$file" "$tmp_rm" >"$tmp_out"
  rm -f "$tmp_rm"
  confirm_and_apply "$file" "$tmp_out"
}

cmd_flatpak_add() {
  local file="" origin="" app_id remotes tmp_out
  while [ $# -gt 0 ]; do
    case "$1" in
    --origin=*) origin="${1#--origin=}" ;;
    --origin)
      shift
      if [ $# -eq 0 ]; then die "Missing value for --origin"; fi
      origin="$1"
      ;;
    -y | --yes) ASSUME_YES=true ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      if [ $# -gt 0 ]; then
        file="$1"
        shift
      fi
      break
      ;;
    -*) die "Unknown option: $1" ;;
    *) if [ -z "$file" ]; then file="$1"; else die "Too many files: $1"; fi ;;
    esac
    shift
  done

  file="$(resolve_flatpak_file "$file")"
  if [ -z "$file" ]; then
    die "No $FLATPAK_FILE found under flake root."
  fi
  check_config_file "$file"

  if ! app_id="$(pick_flatpak_add)"; then
    msg_warn "No flatpak selected."
    exit 0
  fi

  if flatpak_exists "$file" "$app_id"; then
    msg_warn "Already exists: $app_id"
    exit 0
  fi

  origin="$(choose_flatpak_origin "$file" "$origin")"
  if [ -z "$origin" ]; then
    origin="flathub"
  fi
  remotes="$(extract_flatpak_remotes "$file" || true)"
  if [ -n "$remotes" ] && ! printf "%s\n" "$remotes" | grep -qxF "$origin"; then
    msg_warn "Origin '$origin' is not in remotes; adding anyway."
  fi

  tmp_out="$(mktemp)"
  if [ "$origin" = "flathub" ]; then
    flatpak_insert_string "$file" "$app_id" >"$tmp_out"
  else
    if ! grep -q "++" "$file"; then
      rm -f "$tmp_out"
      die "No '++ [...]' attrset block found in $file for origin '$origin'."
    fi
    flatpak_insert_block "$file" "$app_id" "$origin" >"$tmp_out"
  fi
  confirm_and_apply "$file" "$tmp_out"
}

cmd_flatpak_remove() {
  local file="" picks tmp_rm tmp_out
  while [ $# -gt 0 ]; do
    case "$1" in
    -y | --yes) ASSUME_YES=true ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      if [ $# -gt 0 ]; then
        file="$1"
        shift
      fi
      break
      ;;
    -*) die "Unknown option: $1" ;;
    *) if [ -z "$file" ]; then file="$1"; else die "Too many files: $1"; fi ;;
    esac
    shift
  done

  file="$(resolve_flatpak_file "$file")"
  if [ -z "$file" ]; then
    die "No $FLATPAK_FILE found under flake root."
  fi
  check_config_file "$file"

  picks="$(pick_flatpak_remove "$file" || true)"
  if [ -z "$picks" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  tmp_rm="$(mktemp)"
  printf "%s\n" "$picks" | sort -f -u >"$tmp_rm"
  tmp_out="$(mktemp)"
  flatpak_remove_batch "$file" "$tmp_rm" >"$tmp_out"
  rm -f "$tmp_rm"
  confirm_and_apply "$file" "$tmp_out"
}

# ============================================================================
# Usage + main
# ============================================================================
show_usage() {
  printf "%b%s%b — Nix Package Provider\n\n" "${BOLD}" "npp" "${NC}"
  echo "Usage:"
  echo "  npp n a [s] [FILE]          Add nixpkgs package(s) (Tab = multi-select)"
  echo "  npp n r [s] [FILE]          Remove nixpkgs package(s) (Tab = multi-select)"
  echo "  npp n s a [FILE]            Same as 'n a s' (stable)"
  echo "  npp n s r [FILE]            Same as 'n r s' (stable)"
  echo ""
  echo "  npp f a [--origin=X] [FILE] Add a Flatpak package (prompts for origin)"
  echo "  npp f r [FILE]              Remove Flatpak package(s) (Tab = multi-select)"
  echo ""
  echo "Aliases: n/nix, f/flatpak, a/add, r/remove, s/stable."
  echo "Flags: -y/--yes (skip confirm), -h/--help. Env: NPP_FLAKE_ROOT, NO_COLOR."
  echo ""
  echo "Examples:"
  echo "  npp n a               # pick unstable nixpkgs packages"
  echo "  npp n a s             # pick stable nixpkgs packages"
  echo "  npp f a --origin=cordial"
}

main() {
  need_cmd nix-instantiate
  need_cmd awk
  need_cmd diff

  while [ $# -gt 0 ]; do
    case "$1" in
    -y | --yes)
      ASSUME_YES=true
      shift
      ;;
    -h | --help)
      show_usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*) break ;;
    *) break ;;
    esac
  done

  if [ $# -eq 0 ]; then
    show_usage
    exit 1
  fi

  case "$1" in
  n | nix)
    shift
    if [ $# -eq 0 ]; then
      die "Missing subcommand for 'n'. Use: a, r, or s."
    fi
    case "$1" in
    s | stable)
      shift
      if [ $# -eq 0 ]; then
        die "Missing subcommand for 'n s'. Use: a or r."
      fi
      case "$1" in
      a | add)
        shift
        cmd_nix_add s "$@"
        ;;
      r | remove)
        shift
        cmd_nix_remove s "$@"
        ;;
      *) die "Unknown subcommand: $1" ;;
      esac
      ;;
    a | add)
      shift
      cmd_nix_add "$@"
      ;;
    r | remove)
      shift
      cmd_nix_remove "$@"
      ;;
    *) die "Unknown subcommand: $1" ;;
    esac
    ;;
  f | flatpak)
    shift
    if [ $# -eq 0 ]; then
      die "Missing subcommand for 'f'. Use: a or r."
    fi
    case "$1" in
    a | add)
      shift
      cmd_flatpak_add "$@"
      ;;
    r | remove)
      shift
      cmd_flatpak_remove "$@"
      ;;
    *) die "Unknown subcommand: $1" ;;
    esac
    ;;
  -h | --help)
    show_usage
    ;;
  *)
    die "Unknown command: $1"
    ;;
  esac
}

if [ "${NPP_SOURCED:-0}" != "1" ]; then
  main "$@"
fi
