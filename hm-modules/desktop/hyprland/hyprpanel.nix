{ inputs, browser, menu, music, ... }:

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
            left.shortcut1.tooltip = "Launch Browser";
            left.shortcut1.command = "${browser}";
            left.shortcut1.icon = "";
            left.shortcut2.tooltip = "Launch Music Player";
            left.shortcut2.command = "${music}";
            left.shortcut2.icon = "󰝚";
            left.shortcut3.tooltip = "Search";
            left.shortcut3.command = "${menu}";
            left.shortcut3.icon = "";
            left.shortcut4.tooltip = "Launch Vesktop";
            left.shortcut4.command = "vesktop";
            left.shortcut4.icon = "";
          };
          directories.enabled = false;
          stats.enable_gpu = true;
        };
      };
    };
  };
}
