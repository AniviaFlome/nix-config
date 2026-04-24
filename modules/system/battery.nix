{
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;
}
