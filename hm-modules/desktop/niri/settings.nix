{
  config,
  osConfig,
  pkgs,
  ...
}:
{
  programs.niri = {
    package = osConfig.programs.niri.package or pkgs.niri-unstable;
    settings = {
      # includes = lib.mkAfter [ ./extra.kdl ];
      prefer-no-csd = true;
      hotkey-overlay = {
        skip-at-startup = true;
      };
      layout = {
        default-column-width = { };
        background-color = "transparent";
        border = {
          enable = true;
          width = 3;
          active.color = "cba6f7";
          inactive.color = "#505050";
        };
        focus-ring = {
          enable = false;
          width = 4;
          active.color = "cba6f7";
          inactive.color = "#505050";
        };
        gaps = 6;
        struts = {
          left = 4;
          right = 4;
          top = 4;
          bottom = 4;
        };
      };
      # recent-windows = {
      #   debounce-ms = 500;
      #   highlight = {
      #     active-color = "#cba6f7";
      #     urgent-color = "#f38ba8";
      #   };
      #   previews = {
      #     max-height = 480;
      #     max-scale = 0.3;
      #   };
      # };
      input = {
        keyboard = {
          xkb.layout = "tr";
          numlock = true;
        };
        touchpad = {
          disabled-on-external-mouse = false;
          dwt = true;
          dwtp = true;
          natural-scroll = false;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };

      };
      clipboard = {
        disable-primary = true;
      };
      gestures = {
        hot-corners.enable = false;
      };
      overview = {
        backdrop-color = "#181825";
      };
      debug = {
        honor-xdg-activation-with-invalid-serial = { };
      };
      screenshot-path = "${config.xdg.userDirs.pictures}/%Y-%m-%dT%H:%M:%S.png";
      window-rules = [
        {
          draw-border-with-background = false;
          geometry-corner-radius =
            let
              radius = 0.0;
            in
            {
              top-left = radius;
              top-right = radius;
              bottom-left = radius;
              bottom-right = radius;
            };
          clip-to-geometry = true;
        }
        {
          matches = [ { title = "^Picture-in-Picture$"; } ];
          open-floating = true;
        }
        {
          matches = [ { title = "Taunahi"; } ];
          open-focused = false;
        }
      ];
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 144.063;
          };
          scale = 1.25;
          focus-at-startup = true;
          variable-refresh-rate = "on-demand";
          position = {
            x = 0;
            y = 0;
          };
        };
      };
      environment = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "kde";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
      };
    };
  };
}
