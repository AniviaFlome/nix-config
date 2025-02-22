{ pkgs, inputs, ... }:

let
  screenshot = import ./scripts/screenshot.nix pkgs;
in

{
  imports = [
    ./dunst.nix
    ./hyprpaper.nix
#     ./rofi.nix
   ./waybar/default.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$file" = "dolphin";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";

      exec-once = [
        "dunst"
        "hyprpaper"
      ];

      monitor = [
        ",preferred,auto,auto"
      ];

      input = {
        kb_layout = "tr";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
      };

      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7aa)";
        "col.inactive_border" = "rgba(414868aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      windowrule = [ ];

      windowrulev2 = [
        "noblur,title:^()$,class:^()$"
      ];

      plugins = [

      ];

      bind = [
        "$mainMod, return, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, Q, exec, $terminal"
        "$mainMod, E, exec, $file"
        "$mainMod, G, exec, $menu"
        "$mainMod, V, togglefloating,"
        "$mainMod, F, fullscreen,"
        "$mainMod, P, pseudo,"
        "$mainMod, U, togglesplit,"
        "$mainMod SHIFT, P, exec, pavucontrol"
        "$mainMod, M , exec, pamixer --default-source -t"
        "$mainMod SHIFT, M , exec, pamixer -t"
        "$mainMod, F7 , exec, playerctl volume 0.05-"
        "$mainMod, F8 , exec, playerctl volume 0.05+"
        "$mainMod, F9 , exec, playerctl play-pause"
        "$mainMod, F10, exec, playerctl previous"
        "$mainMod, F11, exec, playerctl next"
        "$mainMod, F12, exec, playerctl stop"


        # Screenshot bindings
        "$mainMod ALT, S, exec, grim - | tee ~/pictures/sc/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy"
        "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | tee ~/pictures/sc/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png | wl-copy"

        # Focus movement with vim keys
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # Swap windows
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Resize Windows
        "$mainMod ALT, l, resizeactive, 30 0"
        "$mainMod ALT, h, resizeactive, -30 0"
        "$mainMod ALT, k, resizeactive, 0 -30"
        "$mainMod ALT, j, resizeactive, 0 30"

        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move windows to workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Workspace scroll
        "$mainMod, mouse_up, workspace, e+1"
        "$mainMod, mouse_down, workspace, e-1"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  home.packages = with pkgs; [
    hyprpicker
  ];
}
