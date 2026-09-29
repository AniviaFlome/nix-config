{
  inputs,
  pkgs,
  browser-desktop,
  discord-desktop,
  file,
  file-desktop,
  font,
  font-fixed,
  font-size,
  launcher,
  music-desktop,
  terminal,
  terminal-desktop,
  wallpaper,
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

    configFile.kdeglobals.General = {
      TerminalApplication = terminal;
      TerminalService = terminal-desktop;
    };

    fonts = {
      general = {
        family = font;
        pointSize = builtins.fromJSON font-size;
      };
      fixedWidth = {
        family = font-fixed;
        pointSize = builtins.fromJSON font-size;
      };
      menu = {
        family = font;
        pointSize = builtins.fromJSON font-size;
      };
      toolbar = {
        family = font;
        pointSize = builtins.fromJSON font-size;
      };
    };

    workspace = {
      enableMiddleClickPaste = false;
      colorScheme = "CatppuccinMochaMauve";
      lookAndFeel = "Catppuccin-Mocha-Mauve";
      theme = "default";
      clickItemTo = "select";
      iconTheme = "breeze-dark";
      inherit wallpaper;
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

    hotkeys.commands = {
      launch-terminal = {
        name = "Launch Terminal";
        key = "Meta+T";
        command = terminal;
      };
      launch-file-manager = {
        name = "Launch File Manager";
        key = "Meta+E";
        command = file;
      };
      launch-launcher = {
        name = "Launch Launcher";
        key = "Meta+Space";
        command = launcher;
      };
    };

    shortcuts = {
      kwin = {
        "Window Close" = "Meta+C";
        "Window Maximize" = "Meta+F";
        "Edit Tiles" = "Meta+M";
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
        inherit wallpaper;
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

    session = {
      sessionRestore = {
        restoreOpenApplicationsOnLogin = "whenSessionWasManuallySaved";
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
                "applications:${browser-desktop}"
                "applications:${file-desktop}"
                "applications:${music-desktop}"
                "applications:${discord-desktop}"
                "applications:${terminal-desktop}"
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
