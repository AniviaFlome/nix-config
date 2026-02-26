{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "binder_linux"
    ];
    kernelParams = [

    ];
  };
}
