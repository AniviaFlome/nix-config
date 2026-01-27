{ lib, ... }:
{
  services.glances = {
    enable = lib.mkDefault true;
    openFirewall = lib.mkDefault false; # Managed by Traefik
    port = 61208;
  };
}
