{
  pkgs,
  ...
}:
{
  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = false; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
    extraCompatPackages = with pkgs; [
      dwproton-bin
      proton-ge-bin
      proton-cachyos
    ];
  };
}
