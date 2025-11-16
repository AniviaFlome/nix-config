{
  config,
  pkgs,
  ...
}:
{
  programs.niri = {
    package = with pkgs; niri;
    settings = {
      prefer-no-csd = true;
      hotkey-overlay = {
        skip-at-startup = true;
      };
      layout = {
        background-color = "transparent";
        border = {
          enable = true;
          width = 4;
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
          left = 6;
          right = 6;
          top = 4;
          bottom = 4;
        };
      };
      input = {
        keyboard = {
          xkb.layout = "tr";
          numlock = true;
        };
        touchpad = {
          natural-scroll = false;
          dwt = true;
        };
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
        warp-mouse-to-focus = {
          enable = false;
          mode = "center-xy";
        };
      };
      gestures = {
        hot-corners.enable = false;
      };
      window-rules = [
        {
          matches = [ { title = "^Picture-in-Picture$"; } ];
          open-floating = true;
        }
      ];
      outputs = {
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 144.0;
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
      screenshot-path = "${config.xdg.userDirs.pictures}/%Y-%m-%dT%H:%M:%S.png";
      environment = {
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        QT_QPA_PLATFORM = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
  };
}
