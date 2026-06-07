{
  flake.modules.nixos.firewall = {
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
  flake.modules.nixos.firewall-vps = {
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
