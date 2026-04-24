{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "binder_linux"
      "ntsync"
    ];
    kernelParams = [

    ];
  };
}
