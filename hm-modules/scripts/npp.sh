#!/usr/bin/env dash
# npp — Nix Package Provider
# Add/remove nixpkgs (unstable + stable.xxx) and Flatpak packages from this flake.
# Single-file model: unstable = bare attrs, stable = stable.xxx in pkgs.nix.
#
#   npp n a [s] [--refresh] [FILE]   add nixpkgs, Tab=multi (s = stable.xxx)
#   npp n r [s] [FILE]               remove nixpkgs, Tab=multi (s = stable only)
#   npp f a [--origin=X] [--refresh] [FILE]  add Flatpak (prompts for origin)
#   npp f r [FILE]                   remove Flatpak(s), Tab = multi-select
#
# Global flags: -y / --yes (skip confirm), -h / --help.
# Env: NH_FLAKE overrides flake-root detection, NPP_REFRESH=1 forces
# re-index, NO_COLOR disables color.

set -eu

# ============================================================================
# Configuration
# ============================================================================
DEFAULT_DIR="${HOME}/nix-config"
BACKUP_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/npp-backups"
MAX_BACKUPS=14
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/npp"
FLATPAK_CACHE="$CACHE_DIR/flatpaks.list"
FLATPAK_TTL=86400

ASSUME_YES=false

NIX_FILE="pkgs.nix"
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
      sort -rn | tail -n "+$((MAX_BACKUPS + 1))" | cut -d' ' -f2- |
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
  local root="" flake_ref=""
  flake_ref="${NH_FLAKE:-}"
  case "$flake_ref" in
  *\#*) flake_ref="${flake_ref%%#*}" ;;
  esac
  if [ -n "$flake_ref" ] && [ -d "$flake_ref" ]; then
    echo "$flake_ref"
    return 0
  fi
  if [ -n "$flake_ref" ] && [ -f "$flake_ref" ]; then
    echo "$(dirname "$flake_ref")"
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
  msg_error "Set NH_FLAKE or pass FILE explicitly."
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
  local explicit="${1:-}" root candidate
  if [ -n "$explicit" ]; then
    echo "$explicit"
    return 0
  fi
  root="$(resolve_root)"
  candidate="$root/modules/packages/$NIX_FILE"
  if [ -f "$candidate" ]; then
    echo "$candidate"
    return 0
  fi
  find_one "$root" "$NIX_FILE"
}

resolve_flatpak_file() {
  local explicit="${1:-}" root candidate
  if [ -n "$explicit" ]; then
    echo "$explicit"
    return 0
  fi
  root="$(resolve_root)"
  candidate="$root/modules/packages/$FLATPAK_FILE"
  if [ -f "$candidate" ]; then
    echo "$candidate"
    return 0
  fi
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
  awk '
    function qual(s,   p) {
      p = s
      sub(/#.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      sub(/;.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      if (p ~ /^pkgs\.stable\./) sub(/^pkgs\.stable\./, "stable.", p)
      else if (p ~ /^stable\./) { }
      else sub(/^pkgs\./, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      return p
    }
    function bdepth(line,   t, o, c) {
      t = line
      sub(/#.*$/, "", t)
      o = gsub(/\[/, "[", t)
      c = gsub(/\]/, "]", t)
      return o - c
    }
    BEGIN { in_env = 0; depth = 0 }
    /environment\.systemPackages/ { in_env = 1 }
    in_env {
      d = bdepth($0)
      prev = depth
      depth += d
      if (prev == 0 && depth >= 1) next
      if (depth == 0 && prev > 0) exit
      if (depth != 1) next
      t = $0
      gsub(/^[ \t]+/, "", t)
      gsub(/[ \t]+$/, "", t)
      if (t ~ /^\]/) next
      if (t == "" || t ~ /^#/ || index(t, "[") > 0) next
      b = qual($0)
      if (b != "") print b
    }
  ' "$file"
}

# nix_insert_batch src addfile — stdout is the new file content.
# addfile already contains qualified entries (stable.xxx or xxx), sorted case-insensitively, deduped exactly.
nix_insert_batch() {
  local src="$1" addfile="$2"
  awk -v addfile="$addfile" '
    function qual(s,   p) {
      p = s
      sub(/#.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      sub(/;.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      if (p ~ /^pkgs\.stable\./) sub(/^pkgs\.stable\./, "stable.", p)
      else if (p ~ /^stable\./) { }
      else sub(/^pkgs\./, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      return p
    }
    function bdepth(line,   t, o, c) {
      t = line
      sub(/#.*$/, "", t)
      o = gsub(/\[/, "[", t)
      c = gsub(/\]/, "]", t)
      return o - c
    }
    function emit(q) {
      if (indent == "") indent = "    "
      print indent q
    }
    BEGIN {
      n = 0
      while ((getline l < addfile) > 0) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", l)
        if (l != "") want[++n] = l
      }
      close(addfile)
      wi = 1; in_env = 0; depth = 0; indent = ""
    }
    /environment\.systemPackages/ { in_env = 1 }
    in_env {
      d = bdepth($0)
      prev = depth
      depth += d
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (prev == 0 && depth >= 1) { print line; next }
      if (depth == 0 && prev > 0) {
        while (wi <= n) { emit(want[wi]); wi++ }
        print line; in_env = 0; next
      }
      if (depth != 1) { print line; next }
      if (index(s, "# keep-" "sorted end") > 0) {
        while (wi <= n) { emit(want[wi]); wi++ }
        print line; next
      }
      # NOTE: no flush on lines starting with ] here — at depth 1 those are
      # nested-list closers (e.g. ])) ), not the outer list end. Outer end is
      # handled by the depth==0 branch above.
      if (s == "" || s ~ /^#/ || index(s, "[") > 0) { print line; next }
      if (indent == "") {
        if (match(line, /^[ \t]+/)) indent = substr(line, RSTART, RLENGTH)
        else indent = "    "
      }
      cur = qual(line)
      while (wi <= n && tolower(want[wi]) < tolower(cur)) { emit(want[wi]); wi++ }
      if (wi <= n && want[wi] == cur) wi++
      print line; next
    }
    { print }
    END { if (depth > 0) while (wi <= n) emit(want[wi]) }
  ' "$src"
}

# nix_remove_batch src rmfile — stdout is the new file content.
# Both file entries and rmfile are qualified (stable.xxx or xxx).
# Legacy pkgs.stable.xxx lines qualify to stable.xxx, so they still match.
# Match is exact (case-sensitive); ordering irrelevant.
nix_remove_batch() {
  local src="$1" rmfile="$2"
  awk -v rmfile="$rmfile" '
    function qual(s,   p) {
      p = s
      sub(/#.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      sub(/;.*$/, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      if (p ~ /^pkgs\.stable\./) sub(/^pkgs\.stable\./, "stable.", p)
      else if (p ~ /^stable\./) { }
      else sub(/^pkgs\./, "", p)
      gsub(/^[ \t]+|[ \t]+$/, "", p)
      return p
    }
    function bdepth(line,   t, o, c) {
      t = line
      sub(/#.*$/, "", t)
      o = gsub(/\[/, "[", t)
      c = gsub(/\]/, "]", t)
      return o - c
    }
    BEGIN {
      while ((getline l < rmfile) > 0) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", l)
        if (l != "") kill[l] = 1
      }
      close(rmfile)
      in_env = 0; depth = 0
    }
    /environment\.systemPackages/ { in_env = 1 }
    in_env {
      d = bdepth($0)
      prev = depth
      depth += d
      line = $0; s = line
      gsub(/^[ \t]+/, "", s); gsub(/[ \t]+$/, "", s)
      if (prev == 0 && depth >= 1) { print line; next }
      if (depth == 0 && prev > 0) { print line; in_env = 0; next }
      if (depth != 1) { print line; next }
      if (s ~ /^\]/) { print line; next }
      if (s == "" || s ~ /^#/ || index(s, "[") > 0) { print line; next }
      cur = qual(line)
      if (cur != "" && (cur in kill)) next
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

# Print nix-search-tv index, offline-first for speed (online re-index takes ~25s).
# Usage: nix_search_print <index> [refresh(true/false)]. NPP_REFRESH=1 forces refresh.
nix_search_print() {
  local index="$1" refresh="${2:-false}"
  if [ "${NPP_REFRESH:-0}" = "1" ]; then refresh=true; fi
  if [ "$refresh" = true ]; then
    nix-search-tv print --indexes "$index" 2>/dev/null
  else
    nix-search-tv print --offline --indexes "$index" 2>/dev/null || nix-search-tv print --indexes "$index" 2>/dev/null
  fi
}

pick_nix_add() {
  local stable="${1:-false}" refresh="${2:-false}" fzf_output="" fzf_code=0 query="" selected_lines=""
  need_cmd fzf
  need_cmd nix-search-tv
  if [ "${NPP_REFRESH:-0}" = "1" ]; then refresh=true; fi

  # shellcheck disable=SC2016
  # fzf expands {} at preview time; the $() runs inside fzf, not here.
  # NOTE: no sort -u before fzf on purpose — sort buffers the whole 150k-line
  # index and blocks the UI. awk dedup streams, so fzf opens instantly and a
  # typed name + Enter works without waiting for the list (via --print-query).
  fzf_output="$(
    {
      nix_search_print nixpkgs "$refresh" | sed 's|^|nixpkgs/ |'
      if [ "$stable" != true ]; then
        nix_search_print nur "$refresh" | sed 's|^|nur/ |'
      fi
    } |
      grep -E "^(nixpkgs|nur)/[[:space:]]+[[:alnum:]_.+-]+$" |
      awk '!seen[$0]++' |
      fzf \
        --print-query \
        --prompt='Search Nix package (type name + Enter works instantly, Tab=multi) > ' \
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
  local file="$1" stable="${2:-false}"
  need_cmd fzf
  if [ "$stable" = true ]; then
    extract_nix_packages "$file" | grep -E "^stable\." | sort -f | uniq |
      fzf \
        --prompt='Select stable package(s) to remove (Tab=multi) > ' \
        --border --reverse --ansi \
        --exact \
        --multi \
        --tiebreak=begin,length
  else
    extract_nix_packages "$file" | grep -Ev "^stable\." | sort -f | uniq |
      fzf \
        --prompt='Select package(s) to remove (Tab=multi) > ' \
        --border --reverse --ansi \
        --exact \
        --multi \
        --tiebreak=begin,length
  fi
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
    $1 == t { found = 1; exit }
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
# Match is exact (case-sensitive).
flatpak_remove_batch() {
  local src="$1" rmfile="$2"
  awk -v rmfile="$rmfile" '
    BEGIN {
      while ((getline l < rmfile) > 0) {
        gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", l)
        if (l != "") kill[l] = 1
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
        if (!(existing != "" && (existing in kill))) printf "%s", buf
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
          if (existing != "" && (existing in kill)) next
          print line; next
        }
        in_block = 1; buf = line "\n"; next
      }
      if (s ~ /^"/) {
        cur = s; gsub(/"/, "", cur); sub(/[ \t,;]*$/, "", cur)
        if (cur in kill) next
        print line; next
      }
      print line; next
    }
    { print }
  ' "$src"
}

# Print "application<TAB>name<TAB>description" lines, cached (flatpak search takes ~45s).
# Usage: flatpak_list_cached [refresh(true/false)]. NPP_REFRESH=1 forces refresh.
flatpak_list_cached() {
  local refresh="${1:-false}"
  if [ "${NPP_REFRESH:-0}" = "1" ]; then refresh=true; fi
  mkdir -p "$CACHE_DIR"
  if [ "$refresh" != true ] && [ -s "$FLATPAK_CACHE" ]; then
    if [ -n "$(find "$FLATPAK_CACHE" -mmin -$((FLATPAK_TTL / 60 + 1)) -print 2>/dev/null)" ]; then
      cat "$FLATPAK_CACHE"
      return 0
    fi
  fi
  msg_info "Refreshing Flatpak list (slow first run, cached for 24h)..."
  if flatpak search "" --columns=application,name,description 2>/dev/null >"$FLATPAK_CACHE.tmp"; then
    mv "$FLATPAK_CACHE.tmp" "$FLATPAK_CACHE"
    cat "$FLATPAK_CACHE"
  else
    rm -f "$FLATPAK_CACHE.tmp"
    if [ -s "$FLATPAK_CACHE" ]; then
      msg_warn "Flatpak search failed, using stale cache."
      cat "$FLATPAK_CACHE"
    else
      return 1
    fi
  fi
}

pick_flatpak_add() {
  local refresh="${1:-false}" fzf_output="" fzf_code=0 query="" selected_lines="" selected="" app_id=""
  need_cmd fzf
  need_cmd flatpak
  if [ "${NPP_REFRESH:-0}" = "1" ]; then refresh=true; fi

  fzf_output="$(
    flatpak_list_cached "$refresh" |
      awk -F'\t' '{printf "%s | %s - %s\n", $1, $2, $3}' |
      fzf --print-query --prompt='Search Flatpak (type ID + Enter works instantly) > ' \
        --border --reverse --ansi \
        --exact \
        --tiebreak=begin,length \
        --with-nth=2.. \
        --delimiter='\|'
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
    selected="$query"
  else
    selected="$(printf "%s\n" "$selected_lines" | head -n1)"
  fi

  if [ -z "$selected" ]; then
    return 1
  fi

  # Manual entry (no pipe) or "id | name - desc" line.
  case "$selected" in
  *\|*) app_id="${selected%%|*}" ;;
  *) app_id="$selected" ;;
  esac
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
  extract_flatpak_packages "$file" | sort -f | uniq |
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
  local stable=false refresh=false file="" picks tmp_new tmp_exist tmp_add tmp_out p
  while [ $# -gt 0 ]; do
    case "$1" in
    s | stable) stable=true ;;
    --refresh) refresh=true ;;
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

  file="$(resolve_nix_file "$file")"
  if [ -z "$file" ]; then
    die "No $NIX_FILE found under flake root ($(resolve_root)). npp manages nix-config only; run from ~/nix-config, pass FILE explicitly, or set NH_FLAKE."
  fi
  check_config_file "$file"
  if ! grep -q "environment\.systemPackages" "$file"; then
    die "systemPackages block missing in $file — abort."
  fi

  if ! picks="$(pick_nix_add "$stable" "$refresh")"; then
    msg_warn "No package selected."
    exit 0
  fi
  if [ -z "$picks" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  if [ "$stable" = true ]; then
    if printf "%s\n" "$picks" | grep -q "^nur\."; then
      die "NUR packages cannot go into stable (stable has no NUR scope)."
    fi
  fi

  tmp_new="$(mktemp)"
  tmp_exist="$(mktemp)"
  tmp_add="$(mktemp)"
  tmp_out=""
  # shellcheck disable=SC2064
  trap 'rm -f "$tmp_new" "$tmp_exist" "$tmp_add" $tmp_out' EXIT INT TERM HUP
  printf "%s\n" "$picks" |
    awk -v st="$stable" '
      {
        gsub(/^[ \t]+|[ \t]+$/, "", $0)
        if ($0 == "") next
        b = $0
        sub(/^pkgs\.stable\./, "", b)
        sub(/^stable\./, "", b)
        sub(/^pkgs\./, "", b)
        gsub(/^[ \t]+|[ \t]+$/, "", b)
        if (b == "") next
        if (st == "true") print "stable." b
        else print b
      }' | sort -f | uniq >"$tmp_new"
  extract_nix_packages "$file" | sort -f | uniq >"$tmp_exist" || true
  : >"$tmp_add"
  while IFS= read -r p; do
    if [ -z "$p" ]; then continue; fi
    if grep -qxF "$p" "$tmp_exist" 2>/dev/null; then
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
  nix_insert_batch "$file" "$tmp_add" >"$tmp_out"
  rm -f "$tmp_new" "$tmp_exist" "$tmp_add"
  confirm_and_apply "$file" "$tmp_out"
  trap - EXIT INT TERM HUP
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

  file="$(resolve_nix_file "$file")"
  if [ -z "$file" ]; then
    die "No $NIX_FILE found under flake root ($(resolve_root)). npp manages nix-config only; run from ~/nix-config, pass FILE explicitly, or set NH_FLAKE."
  fi
  check_config_file "$file"
  if ! grep -q "environment\.systemPackages" "$file"; then
    die "systemPackages block missing in $file — abort."
  fi

  picks="$(pick_nix_remove "$file" "$stable" || true)"
  if [ -z "$picks" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  tmp_rm="$(mktemp)"
  tmp_out=""
  # shellcheck disable=SC2064
  trap 'rm -f "$tmp_rm" $tmp_out' EXIT INT TERM HUP
  printf "%s\n" "$picks" | sort -f | uniq >"$tmp_rm"
  tmp_out="$(mktemp)"
  nix_remove_batch "$file" "$tmp_rm" >"$tmp_out"
  rm -f "$tmp_rm"
  confirm_and_apply "$file" "$tmp_out"
  trap - EXIT INT TERM HUP
}

cmd_flatpak_add() {
  local file="" origin="" refresh=false app_id remotes tmp_out
  while [ $# -gt 0 ]; do
    case "$1" in
    --origin=*) origin="${1#--origin=}" ;;
    --origin)
      shift
      if [ $# -eq 0 ]; then die "Missing value for --origin"; fi
      origin="$1"
      ;;
    --refresh) refresh=true ;;
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
    die "No $FLATPAK_FILE found under flake root ($(resolve_root)). npp manages nix-config only; run from ~/nix-config, pass FILE explicitly, or set NH_FLAKE."
  fi
  check_config_file "$file"

  if ! app_id="$(pick_flatpak_add "$refresh")"; then
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
  # shellcheck disable=SC2064
  trap 'rm -f $tmp_out' EXIT INT TERM HUP
  if [ "$origin" = "flathub" ]; then
    flatpak_insert_string "$file" "$app_id" >"$tmp_out"
  else
    if ! grep -q "++" "$file"; then
      rm -f "$tmp_out"
      trap - EXIT INT TERM HUP
      die "No '++ [...]' attrset block found in $file for origin '$origin'."
    fi
    flatpak_insert_block "$file" "$app_id" "$origin" >"$tmp_out"
  fi
  confirm_and_apply "$file" "$tmp_out"
  trap - EXIT INT TERM HUP
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
    die "No $FLATPAK_FILE found under flake root ($(resolve_root)). npp manages nix-config only; run from ~/nix-config, pass FILE explicitly, or set NH_FLAKE."
  fi
  check_config_file "$file"

  picks="$(pick_flatpak_remove "$file" || true)"
  if [ -z "$picks" ]; then
    msg_warn "No package selected."
    exit 0
  fi

  tmp_rm="$(mktemp)"
  tmp_out=""
  # shellcheck disable=SC2064
  trap 'rm -f "$tmp_rm" $tmp_out' EXIT INT TERM HUP
  printf "%s\n" "$picks" | sort -f | uniq >"$tmp_rm"
  tmp_out="$(mktemp)"
  flatpak_remove_batch "$file" "$tmp_rm" >"$tmp_out"
  rm -f "$tmp_rm"
  confirm_and_apply "$file" "$tmp_out"
  trap - EXIT INT TERM HUP
}

# ============================================================================
# Usage + main
# ============================================================================
show_usage() {
  printf "%b%s%b — Nix Package Provider\n\n" "${BOLD}" "npp" "${NC}"
  echo "Usage:"
  echo "  npp n a [s] [--refresh] [FILE]  Add nixpkgs (Tab=multi, s=stable.xxx, type+Enter=instant)"
  echo "  npp n r [s] [FILE]              Remove nixpkgs (Tab=multi, s=stable only)"
  echo "  npp n s a [FILE]                Same as 'n a s' (stable)"
  echo "  npp n s r [FILE]                Same as 'n r s' (stable)"
  echo ""
  echo "  npp f a [--origin=X] [--refresh] [FILE] Add Flatpak (type ID+Enter=instant)"
  echo "  npp f r [FILE]                  Remove Flatpak package(s) (Tab = multi-select)"
  echo ""
  echo "Aliases: n/nix, f/flatpak, a/add, r/remove, s/stable."
  echo "Flags: -y/--yes (skip confirm), -h/--help, --refresh (re-index, slow)."
  echo "Env: NH_FLAKE, NPP_REFRESH=1, NO_COLOR."
  echo ""
  echo "Examples:"
  echo "  npp n a               # pick unstable nixpkgs packages (bare attrs)"
  echo "  npp n a s             # pick stable nixpkgs packages (stable.xxx)"
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
