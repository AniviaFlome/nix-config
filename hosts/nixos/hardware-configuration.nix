{ config, lib, pkgs, modulesPath, username, ... }: {

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/475aa60b-6e59-4402-a968-cd4432539be1";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6D9E-AA0E";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/e0de6d1b-f9d9-4a89-ab2a-8cd7aadc43dd";
    fsType = "btrfs";
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
  environment.systemPackages = with pkgs; [polychromatic];
}
