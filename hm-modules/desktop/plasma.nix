{ pkgs, inputs, file, terminal, wallpaper, ... }:

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

    workspace = {
      enableMiddleClickPaste = false;
      colorScheme =  "CatppuccinMochaMauve";
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
                "applications:zen-beta.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:spotify.desktop"
                "applications:vesktop.desktop"
                "applications:kitty.desktop"
              ];
            };
          }
          "org.kde.plasma.panelspacer"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
              ];
              hidden = [
                "org.kde.kdeconnect"
                "org.kde.plasma.brightness"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.keyboardlayout"
                "org.kde.plasma.manage-inputmethod"
                "org.kde.plasma.mediacontroller"
                "org.kde.plasma.notifications"
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
