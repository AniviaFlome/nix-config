{ config, lib, pkgs, modulesPath, username, ... }: {

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/e0de6d1b-f9d9-4a89-ab2a-8cd7aadc43dd";
    fsType = "btrfs";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ]; # Load nvidia driver for Xorg and Wayland

  hardware.nvidia = {
    modesetting.enable = true; # Modesetting is required.
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.openrazer = {
    enable = true;
    users = [ "${username}" ];
  };
  environment.systemPackages = with pkgs; [ polychromatic ];
}
