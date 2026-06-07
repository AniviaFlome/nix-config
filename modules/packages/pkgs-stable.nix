{
  flake.modules.nixos.pkgs-stable =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs.stable; [
        kdePackages.kdenlive
        losslesscut-bin
      ];
    };
}
