{
  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = false;
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
  };
}
