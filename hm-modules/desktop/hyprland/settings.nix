{
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    monitor = [ "eDP-1, 1920x1080@144.063, 0x0, 1.25, vrr, 1" ];

    input = {
      kb_layout = "tr";
      numlock_by_default = true;
      follow_mouse = 1;
      sensitivity = 0;
      accel_profile = "flat";
      touchpad = {
        disable_while_typing = true;
        natural_scroll = false;
        tap-to-click = true;
      };
    };

    general = {
      layout = "scrolling";
      gaps_in = 3;
      gaps_out = 6;
      border_size = 3;
      "col.active_border" = "rgba(cba6f7ff)";
      "col.inactive_border" = "rgba(505050ff)";
    };

    decoration = {
      rounding = 0;
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
      enabled = true;
      bezier = [
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "critDamp, 0.22, 1, 0.36, 1"
        "movement, 0.25, 1, 0.5, 1"
      ];
      animation = [
        "windowsIn, 1, 2, easeOutExpo, slide"
        "windowsOut, 1, 2, easeOutExpo, slide"
        "windowsMove, 1, 3, movement"
        "windows, 1, 2, easeOutExpo, slide"
        "fade, 1, 2, easeOutExpo"
        "border, 1, 3, critDamp"
        "workspaces, 1, 3, critDamp, slidevert"
      ];
    };

    scrolling = {
      fullscreen_on_one_column = true;
      column_width = 0.8;
      direction = "right";
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    master = {
      new_status = "slave";
    };

    misc = {
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };

    windowrule = [
      "float on, match:title Picture-in-Picture"
      "pin on, match:title Picture-in-Picture"
      "keep_aspect_ratio on, match:title Picture-in-Picture"
    ];

    cursor = {
      no_warps = true;
    };

    env = [
      "XDG_CURRENT_DESKTOP,Hyprland"
      "XDG_SESSION_TYPE,wayland"
      "QT_QPA_PLATFORM,wayland"
      "QT_QPA_PLATFORMTHEME,kde"
      "MOZ_ENABLE_WAYLAND,1"
      "NIXOS_OZONE_WL,1"
      "QML2_IMPORT_PATH,${
        lib.concatStringsSep ":" [
          "${pkgs.quickshell}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtdeclarative}/lib/qt-6/qml"
          "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"
          "${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml"
        ]
      }"
    ];
  };
}
