{
  flake.modules.nixos.kernel =
    { pkgs, ... }:
    {
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.kernelModules = [
        "binder_linux"
        "ntsync"
      ];
    };
}
