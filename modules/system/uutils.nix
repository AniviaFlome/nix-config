{
  flake.modules.nixos.uutils =
    { pkgs, lib, ... }:
    {
      environment.systemPackages = [
        (lib.hiPrio pkgs.uutils-coreutils-noprefix)
      ];
    };
}
