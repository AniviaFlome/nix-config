{
  inputs,
  wallpaper,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.dms-plugin-registry.homeModules.default
  ];

  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
    systemd = {
      enable = false;
      restartIfChanged = true;
    };

    niri = {
      enableKeybinds = false;
      enableSpawn = true;
      includes = {
        enable = true;
        override = false;
      };
    };

    plugins = {
      dankKDEConnect.enable = true;
      linuxWallpaperEngine.enable = true;
    };

    settings = {
      builtInPluginSettings = {

      };
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = inputs.dms-plugin-registry + "/themes/catppuccin/theme.json";
      controlCenterShowMicPercent = true;
      waveProgressEnabled = false;
      scrollTitleEnabled = false;
      audioVisualizerEnabled = false;
      appIdSubstitutions = [ ];
      useAutoLocation = true;

      # Sleep
      acMonitorTimeout = 300;
      acLockTimeout = 900;
      acSuspendTimeout = 900;
      lockBeforeSuspend = true;

      osdPowerProfileEnabled = true;
      lowerDisplayRefreshRateOnBattery = true;

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
          innerPadding = 0;
          openOnOverview = true;
          fullscreenDetection = false;
          squareCorners = true;
          spacing = 0;
          fontScale = 0.95;
          leftWidgets = [
            {
              id = "launcherButton";
              enabled = true;
            }
            {
              id = "cpuTemp";
              enabled = true;
              minimumWidth = true;
            }
            {
              id = "cpuUsage";
              enabled = true;
              minimumWidth = true;
            }
            {
              id = "memUsage";
              enabled = true;
              minimumWidth = true;
              showInGb = false;
            }
          ];
          centerWidgets = [
            {
              id = "workspaceSwitcher";
              enabled = true;
            }
          ];
          rightWidgets = [
            {
              id = "systemTray";
              enabled = true;
            }
            {
              id = "notificationButton";
              enabled = true;
            }
            {
              id = "dankKDEConnect";
              enabled = true;
            }
            {
              id = "battery";
              enabled = true;
            }
            {
              id = "controlCenterButton";
              enabled = true;
            }
            {
              id = "clock";
              enabled = true;
            }
            {
              id = "powerMenuButton";
              enabled = true;
            }
          ];
        }
      ];
    };

    session = {
      wallpaperPath = wallpaper;
      showThirdPartyPlugins = true;
    };
  };
}
