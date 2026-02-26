{
  config,
  font,
  font-fixed,
  inputs,
  pkgs,
  terminal,
  wallpaper,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];
      states = {
        screen-recorder = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        kaomoji-provider = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        timer = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
        privacy-indicator = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 1;
    };
    pluginSettings = {
      privacy-indicator = {
        hideInactive = true;
        removeMargins = true;
        activeColor = "primary";
        inactiveColor = "none";
      };
      screen-recorder = {
        audioCodec = "opus";
        audioSource = "default_output";
        colorRange = "limited";
        directory = config.xdg.userDirs.videos;
        frameRate = 60;
        quality = "very_high";
        showCursor = true;
        videoCodec = "h264";
        videoSource = "portal";
      };
    };
    settings = {
      appLauncher = {
        backgroundOpacity = 1;
        customLaunchPrefix = "";
        customLaunchPrefixEnabled = false;
        enableClipboardHistory = true;
        pinnedExecs = [ ];
        position = "center";
        sortByMostUsed = true;
        terminalCommand = terminal;
        useApp2Unit = true;
      };
      audio = {
        cavaFrameRate = 60;
        mprisBlacklist = [ ];
        preferredPlayer = "";
        visualizerQuality = "high";
        visualizerType = "linear";
        volumeOverdrive = false;
        volumeStep = 5;
      };
      bar = {
        backgroundOpacity = 1;
        density = "default";
        exclusive = true;
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [ ];
        outerCorners = false;
        position = "top";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "SystemMonitor";
              showCpuTemp = true;
              showCpuUsage = true;
              showMemoryUsage = true;
            }
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            {
              id = "MediaMini";
              labelMode = "name";
              hideUnoccupied = true;
            }
          ];
          center = [
            {
              id = "Workspace";
              labelMode = "none";
              hideUnoccupied = false;
            }
          ];
          right = [
            {
              id = "Tray";
              blacklist = [
                "JavaEmbdedded"
              ];
              colorizeIcons = false;
              drawerEnabled = false;
            }
            {
              id = "NotificationHistory";
              hideWhenZero = true;
              showUnreadBadge = false;
            }
            {
              id = "Volume";
              displayMode = "onhover";
            }
            {
              id = "Battery";
              displayMode = "on-hover";
              warningThreshold = 20;
            }
            { id = "plugin:privacy-indicator"; }
            {
              id = "Clock";
              clockColor = "primary";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };
      battery.chargingMode = 0;
      brightness = {
        brightnessStep = 5;
        enableDdcSupport = false;
        enforceMinimum = true;
      };
      colorSchemes = {
        darkMode = true;
        generateTemplatesForPredefined = true;
        manualSunrise = "06:30";
        manualSunset = "23:30";
        matugenSchemeType = "scheme-fruit-salad";
        predefinedScheme = "Catppuccin";
        schedulingMode = "off";
        useWallpaperColors = false;
      };
      controlCenter = {
        cards = [
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "plugin:timer"; }
            {
              id = "plugin:screen-recorder";
              defaultSettings = {
                audioCodec = "opus";
                audioSource = "default_output";
                colorRange = "limited";
                copyToClipboard = false;
                directory = "";
                filenamePattern = "recording_yyyyMMdd_HHmmss";
                frameRate = "60";
                hideInactive = false;
                iconColor = "none";
                quality = "very_high";
                resolution = "original";
                showCursor = true;
                videoCodec = "h264";
                videoSource = "portal";
              };
            }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }

          ];
        };
      };
      dock = {
        enabled = false;
      };
      general = {
        animationDisabled = false;
        animationSpeed = 1.75;
        avatarImage = null;
        compactLockScreen = false;
        dimDesktop = true;
        enableShadows = true;
        forceBlackScreenCorners = false;
        language = "";
        lockOnSuspend = true;
        radiusRatio = 1;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showScreenCorners = true;
      };
      location = {
        name = "Beytepe, Turkey";
        weatherEnabled = true;
        firstDayOfWeek = 1;
        monthBeforeDay = false;
        showCalendarEvents = true;
        showCalendarWeather = true;
        showWeekNumberInCalendar = false;
      };
      network.wifiEnabled = true;
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "23:30";
        nightTemp = "4500";
      };
      notifications = {
        enabled = true;
        backgroundOpacity = 1;
        criticalUrgencyDuration = 15;
        location = "top_right";
      };
      ui = {
        fontDefault = font;
        fontDefaultScale = 1;
        fontFixed = font-fixed;
        fontFixedScale = 1;
        panelsAttachedToBar = true;
        settingsPanelAttachToBar = true;
        tooltipsEnabled = true;
      };
      wallpaper = {
        enabled = true;
        defaultWallpaper = wallpaper;
        directory = dirOf wallpaper;
        fillMode = "crop";
        recursiveSearch = true;
      };
    };
  };

  home.packages = with pkgs; [
    app2unit
    cava
    cliphist
    gpu-screen-recorder
    pwvucontrol
    wlsunset
  ];
}
