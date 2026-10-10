{
  systemd.oomd = {
    enable = true;
    settings.OOM = {
      SwapUsedLimit = "95%";
      DefaultMemoryPressureDurationSec = "60s";
    };
  };
}
