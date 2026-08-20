{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
    kernelModules = [
      "binder_linux"
      "udmabuf"
      "ntsync"
    ];
    kernelParams = [

    ];
  };

  hardware.usbStorage.manageShutdown = true;
}
