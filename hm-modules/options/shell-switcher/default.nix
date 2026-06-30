{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.shell-switcher;

  stateDir = "${config.xdg.stateHome}/shell-switcher";
  activeFile = "${stateDir}/active";
  inherit (cfg) logFile;

  profiles = [
    "noctalia"
    "caelestia"
    "dms"
  ];

  profileList = lib.concatStringsSep " " profiles;

  qmlPkg = pkgs.runCommand "shell-switcher-qml" { } ''
    cp -r ${./.} "$out"
    chmod -R u+w "$out"
  '';

  startShell = pkgs.writeShellScriptBin "start-shell" ''
    set -uo pipefail

    profile="''${1:-}"
    if [ -z "$profile" ]; then
      if [ -f "${activeFile}" ]; then
        profile="$(tr -d '[:space:]' < "${activeFile}")"
      fi
      if [ -z "$profile" ] || ! echo "${profileList}" | grep -qw "$profile"; then
        profile="${cfg.defaultProfile}"
      fi
    fi

    if ! echo "${profileList}" | grep -qw "$profile"; then
      echo "shell-switcher: unknown profile '$profile'" >&2
      exit 1
    fi

    mkdir -p "${stateDir}"

    log_msg() {
      printf '[%s] start-shell: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "${logFile}"
    }

    log_msg "activating $profile"

    # ponytail: no lockfiles, no process patterns from other projects — just kill + start
    case "$profile" in
      noctalia)
        ${pkgs.procps}/bin/pkill -u "$USER" -f "caelestia" 2>/dev/null || true
        ${pkgs.procps}/bin/pkill -u "$USER" -f "qs.*-c.*dms" 2>/dev/null || true
        sleep 0.3
        noctalia-shell -d &
        ;;
      caelestia)
        ${pkgs.procps}/bin/pkill -u "$USER" -f "noctalia" 2>/dev/null || true
        ${pkgs.procps}/bin/pkill -u "$USER" -f "qs.*-c.*dms" 2>/dev/null || true
        sleep 0.3
        if command -v caelestia-shell >/dev/null 2>&1; then
          caelestia-shell -d &
        elif command -v caelestia >/dev/null 2>&1; then
          caelestia shell -d &
        else
          log_msg "caelestia not found"
          exit 1
        fi
        ;;
      dms)
        ${pkgs.procps}/bin/pkill -u "$USER" -f "noctalia" 2>/dev/null || true
        ${pkgs.procps}/bin/pkill -u "$USER" -f "caelestia" 2>/dev/null || true
        sleep 0.3
        dms run -d
        ;;
    esac

    printf '%s\n' "$profile" > "${activeFile}"
    log_msg "now active: $profile"
  '';

  shellSelector = pkgs.writeShellScriptBin "shell-selector" ''
    set -uo pipefail

    action="''${1:-toggle}"
    target="''${2:-}"

    log_msg() {
      printf '[%s] shell-selector: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "${logFile}"
    }

    guess_active() {
      if [ -f "${activeFile}" ]; then
        local stored
        stored="$(tr -d '[:space:]' < "${activeFile}" 2>/dev/null || true)"
        if echo "${profileList}" | grep -qw "$stored"; then
          printf '%s' "$stored"
          return 0
        fi
      fi
      if ${pkgs.procps}/bin/pgrep -u "$USER" -f "noctalia" >/dev/null 2>&1; then
        printf noctalia
      elif ${pkgs.procps}/bin/pgrep -u "$USER" -f "caelestia" >/dev/null 2>&1; then
        printf caelestia
      elif ${pkgs.procps}/bin/pgrep -u "$USER" -f "qs.*-c.*dms" >/dev/null 2>&1; then
        printf dms
      else
        printf '%s' "${cfg.defaultProfile}"
      fi
    }

    pick_monitor() {
      if command -v hyprctl >/dev/null 2>&1 && command -v ${pkgs.jq}/bin/jq >/dev/null 2>&1; then
        hyprctl monitors -j 2>/dev/null | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .name' | head -n1
      fi
    }

    is_selector_up() {
      ${pkgs.procps}/bin/pgrep -u "$USER" -f "qs.*-c.*shell-switcher" >/dev/null 2>&1
    }

    kill_selector() {
      ${pkgs.procps}/bin/pkill -u "$USER" -f "qs.*-c.*shell-switcher" >/dev/null 2>&1 || true
    }

    case "$action" in
      switch)
        if [ -z "$target" ] || ! echo "${profileList}" | grep -qw "$target"; then
          log_msg "invalid switch target: ''${target:-empty}"
          exit 1
        fi
        log_msg "direct switch to $target"
        exec "${startShell}/bin/start-shell" "$target"
        ;;
      toggle)
        if is_selector_up; then
          kill_selector
          exit 0
        fi
        local_monitor="$(pick_monitor)"
        local_active="$(guess_active)"
        log_msg "overlay on monitor=''${local_monitor:-auto} active=''${local_active:-unknown}"
        SHELL_SWITCHER_MONITOR="$local_monitor" \
        SHELL_SWITCHER_ACTIVE="$local_active" \
        SHELL_SWITCHER_SCRIPT="shell-selector" \
        qs -c shell-switcher -p "${qmlPkg}" >/dev/null 2>&1 &
        ;;
      close)
        kill_selector
        ;;
      *)
        log_msg "unknown action: $action"
        exit 1
        ;;
    esac
  '';
in
{
  options.programs.shell-switcher = {
    enable = lib.mkEnableOption "shell switcher overlay";
    logFile = lib.mkOption {
      type = lib.types.str;
      default = "/tmp/shell-switcher.log";
      description = "Path to log file.";
    };
    defaultProfile = lib.mkOption {
      type = lib.types.enum profiles;
      default = "noctalia";
      description = "Profile used when no state file exists.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.quickshell
      startShell
      shellSelector
    ];

    xdg.configFile."quickshell/shell-switcher" = {
      force = true;
      source = qmlPkg;
    };

    home.activation.seedShellSwitcherState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${stateDir}"
      if [ ! -f "${activeFile}" ]; then
        $DRY_RUN_CMD printf '%s\n' "${cfg.defaultProfile}" > "${activeFile}"
      fi
    '';
  };
}
