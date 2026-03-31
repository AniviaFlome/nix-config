{
  inputs,
  wallpaper,
  ...
}:
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
  ];

  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = false;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    niri = {
      enableKeybinds = false;
      enableSpawn = true;
      includes = {
        enable = true;
        override = false;
      };
    };

    plugins.dankKDEConnect = {
      enable = true;
      src = "${inputs.dms-plugins}/DankKDEConnect";
      settings = {
        enabled = true;
      };
    };

    settings = {
      builtInPluginSettings = {

      };
      currentThemeName = "custom";
      currentThemeCategory = "custom";
      customThemeFile = ./catppuccin/theme.json;
      controlCenterShowMicPercent = true;
      waveProgressEnabled = false;
      scrollTitleEnabled = false;
      audioVisualizerEnabled = false;
      appIdSubstitutions = [ ];
      useAutoLocation = true;
      acMonitorTimeout = 180;
      acLockTimeout = 300;
      acSuspendTimeout = 300;
      lockBeforeSuspend = true;
      osdPowerProfileEnabled = true;
      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [ "all" ];
          showOnLastDisplay = true;
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
          innerPadding = 0;
          openOnOverview = true;
        }
      ];
    };

    session = {
      wallpaperPath = wallpaper;
      showThirdPartyPlugins = true;
    };

  };
}
