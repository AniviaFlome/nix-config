{ inputs, ... }:

let
  browser-cmd = "flatpak run app.zen_browser.zen";
  browser-name = "Zen Browser";
  music-cmd = "youtube-music";
  music-name = "Youtube Music";
in

{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    enable = true;
    hyprland.enable = true;
    overwrite.enable = true;
    overlay.enable = true;

    theme = "catppuccin_mocha";

    layout = {
      "bar.layouts" = {
        "0" = {
          left = [ "dashboard" "workspaces" ];
          middle = [ "media" ];
          right = [ "volume" "systray" "notifications" ];
        };
      };
    };

    settings = {
      theme = {
        font = {
          name = "CaskaydiaCove NF";
          size = "16px";
        };
      };

      bar = {
        battery = {
          label = false;
        };
        launcher = {
          autoDetectIcon = true;
        };
        workspaces = {
          show_icons = true;
          workspaces = 10;
          reverse_scroll = true;
        };
      };

      menus = {
        dashboard = {
          shortcuts = {
            left.shortcut1.tooltip = "${browser-name}";
            left.shortcut1.command = "${browser-cmd}";
            left.shortcut1.icon = "󰇩";
            left.shortcut2.tooltip = "${music-name}";
            left.shortcut2.command = "${music-cmd}";
            left.shortcut2.icon = "";
          };
          directories.enabled = true;
          stats.enable_gpu = true;
        };
      };
    };
  };
}
