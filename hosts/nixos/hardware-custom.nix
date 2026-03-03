{
  config,
  pkgs,
  inputs,
  username,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.asus-battery
  ];

  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/3858E77C58E736F2";
    fsType = "ntfs";
    options = [
      "rw"
      "uid=1000"
      "nofail"
    ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = true;

  boot.kernelParams = [
    "rcutree.enable_rcu_lazy=1"
    "rtc_cmos.use_acpi_alarm=1"
    "video=1920x1080"
  ];

  services.xserver.videoDrivers = [ "nvidia" ]; # Load nvidia driver for Xorg and Wayland

  hardware.nvidia = {
    modesetting.enable = true; # Modesetting is required.
    powerManagement = {
      enable = true; # Needed for sleep.
      finegrained = false;
    };
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  hardware.openrazer = {
    enable = true;
    users = [
      "${username}"
    ];
  };

  services.asusd = {
    enable = true;
  };

  programs.rog-control-center = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    polychromatic
  ];
}
