{ config, lib, pkgs, modulesPath, username, ... }:

{
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/e0de6d1b-f9d9-4a89-ab2a-8cd7aadc43dd";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "autodefrag" ];
  };
  fileSystems."/mnt/hdd2" = {
    device = "/dev/disk/by-uuid/1DE102920C98B313";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
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
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

#   hardware.openrazer = {
#     enable = true;
#     users = [ "${username}" ];
#   };
#   environment.systemPackages = with pkgs; [ polychromatic ];
}
