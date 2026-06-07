{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        package = pkgs.millennium-steam;
        remotePlay.openFirewall = false;
        dedicatedServer.openFirewall = false;
        localNetworkGameTransfers.openFirewall = false;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          dwproton-bin
          proton-cachyos-bin
        ];
      };
    };

  flake.modules.homeManager.steam = {
    imports = [ ./steam-compat-tools.nix ];

    programs.steam-compat-tools.enable = true;
  };
}
