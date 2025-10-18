{
  inputs,
  browser,
  menu,
  music,
  ...
}:

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
          left = [
            "dashboard"
            "workspaces"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "systray"
            "notifications"
          ];
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
            left = {
              shortcut1 = {
                tooltip = "Launch Browser";
                command = "${browser}";
                icon = "";
              };
              shortcut2 = {
                tooltip = "Launch Music Player";
                command = "${music}";
                icon = "󰝚";
              };
              shortcut3 = {
                tooltip = "Search";
                command = "${menu}";
                icon = "";
              };
              shortcut4 = {
                tooltip = "Launch Vesktop";
                command = "vesktop";
                icon = "";
              };
            };
          };
          directories.enabled = false;
          stats.enable_gpu = true;
        };
      };
    };
  };
}
