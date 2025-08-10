{ config, lib, pkgs-stable, modulesPath, username, ... }:

{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    memoryMax = 8589934592;
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ]; # Load nvidia driver for Xorg and Wayland

  hardware.nvidia = {
    modesetting.enable = true; # Modesetting is required.
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.openrazer = {
    enable = true;
    users = [ "${username}" ];
  };

  environment.systemPackages = with pkgs-stable; [ polychromatic ];
}
