{
  programs.niri = {
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
          active = {
            color = "cba6f7";
          };
          inactive = {
            color = "#505050";
          };
        };
         focus-ring = {
           enable = false;
         };
        gaps = 10;
        struts = {
          left = 12;
          right = 12;
          top = 4;
          bottom = 4;
        };
      };

      input = {
        keyboard.xkb.layout = "tr";
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = false;
      };

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
          position = { x = 0; y = 0; };
        };
      };

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        QT_QPA_PLATFORM = "wayland";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        SDL_VIDEODRIVER = "wayland";
        PROTON_ENABLE_WAYLAND = "1";
        PROTON_USE_NTSYNC= "1";
      };
    };
  };
}
