{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    protontricks.enable = true;
    package = pkgs.steam.override {
      extraLibraries = p: with p; [
        libidn2
        libpsl
        nghttp2.lib
        openssl
        rtmpdump
      ];
    };
  };

  system.activationScripts.protonup-sh = ''
    protonup -y
  '';
}
