{
  pkgs,
  inputs,
  file,
  terminal,
  wallpaper,
  browser,
  ...
}:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  home.packages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
  ];

  programs.plasma = {
    enable = true;

    startup.startupScript = {
      vesktop = {
        text = "vesktop --start-minimized";
      };
      steam = {
        text = "steam -silent";
      };
    };

    configFile.kdeglobals.General = {
      TerminalApplication = "${terminal}";
      TerminalService = "${terminal}.desktop";
    };

    desktop = {
      mouseActions.middleClick = null;
    };

    workspace = {
      enableMiddleClickPaste = false;
      colorScheme = "CatppuccinMochaMauve";
      lookAndFeel = "Catppuccin-Mocha-Mauve";
      theme = "default";
      clickItemTo = "select";
      wallpaper = "${wallpaper}";
    };

    input = {
      mice = [
        {
          enable = true;
          accelerationProfile = "none";
          name = "Razer DeathAdder V2 Mini";
          productId = "008c";
          vendorId = "1532";
        }
      ];
    };

    hotkeys.commands."launch-terminal" = {
      name = "Launch Terminal";
      key = "Meta+T";
      command = "${terminal}";
    };
    hotkeys.commands."launch-file-manager" = {
      name = "Launch File Manager";
      key = "Meta+E";
      command = "${file}";
    };

    shortcuts = {
      kwin = {
        "Toggle Tiles Editor" = " ";
        "Window Close" = "Meta+C";
        "Window Maximize" = "Meta+F";
      };
    };

    kwin = {
      edgeBarrier = 0;
      effects = {
        shakeCursor.enable = false;
      };
      virtualDesktops = {
        names = [
          "Desktop 1"
          "Desktop 2"
          "Desktop 3"
          "Desktop 4"
        ];
        number = 4;
        rows = 2;
      };
    };

    kscreenlocker = {
      autoLock = true;
      lockOnResume = true;
      timeout = 300;
      appearance = {
        wallpaper = "${wallpaper}";
      };
    };

    powerdevil = {
      battery = {
        dimDisplay = {
          enable = true;
          idleTimeout = 180;
        };
      };
    };

    panels = [
      {
        location = "bottom";
        widgets = [
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          {
            iconTasks = {
              launchers = [
                "applications:${browser}.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:spotify.desktop"
                "applications:vesktop.desktop"
                "applications:${terminal}.desktop"
              ];
            };
          }
          "org.kde.plasma.panelspacer"
          {
            systemTray.items = {
              shown = [ "org.kde.plasma.battery" ];
              hidden = [
                "org.kde.kdeconnect"
                "org.kde.plasma.brightness"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.manage-inputmethod"
                "org.kde.plasma.mediacontroller"
                "JavaEmbeddedFrame"
              ];
            };
          }
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
