{
  systemd.oomd = {
    enable = true;
    settings.OOM = {
      SwapUsedLimit = "90%";
      DefaultMemoryPressureDurationSec = "20s";
    };
  };
}
