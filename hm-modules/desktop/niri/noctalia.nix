{
  config,
  inputs,
  terminal,
  wallpaper,
  ...
}:
{
  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia-shell = {
    enable = true;
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
        useApp2Unit = false;
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
        density = "compact";
        exclusive = true;
        floating = false;
        marginHorizontal = 0.25;
        marginVertical = 0.25;
        monitors = [ ];
        outerCorners = true;
        position = "right";
        showCapsule = false;
        widgets = {
          left = [
            {
              id = "SidePanelToggle";
              useDistroLogo = false;
            }
            { id = "WiFi"; }
            { id = "Bluetooth"; }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 20;
            }
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
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
            { id = "ScreenRecorder"; }
            { id = "WallpaperSelector"; }
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
        animationSpeed = 1.5;
        avatarImage = null;
        compactLockScreen = false;
        dimDesktop = true;
        enableShadows = true;
        forceBlackScreenCorners = false;
        language = "";
        lockOnSuspend = true;
        radiusRatio = 0.2;
        scaleRatio = 1;
        screenRadiusRatio = 1;
        shadowDirection = "bottom_right";
        shadowOffsetX = 2;
        shadowOffsetY = 3;
        showScreenCorners = false;
      };
      location = {
        name = "Beytepe, Turkey";
        weatherEnabled = true;
        firstDayOfWeek = -1;
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
        manualSunset = "18:30";
        nightTemp = "4000";
      };
      notifications = {
        enabled = true;
        backgroundOpacity = 1;
        criticalUrgencyDuration = 15;
        location = "top_right";
      };
      screenRecorder = {
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
      ui = {
        fontDefault = "Roboto";
        fontDefaultScale = 1;
        fontFixed = "DejaVu Sans Mono";
        fontFixedScale = 1;
        panelsAttachedToBar = true;
        settingsPanelAttachToBar = false;
        tooltipsEnabled = true;
      };
      wallpaper = {
        enabled = true;
        defaultWallpaper = wallpaper;
        directory = dirOf wallpaper;
        transitionType = "random";
      };
    };
  };
}
