{
  flake.modules.nixos.glances =
    { lib, ... }:
    {
      services.glances = {
        enable = lib.mkDefault true;
        openFirewall = lib.mkDefault false;
        port = 61208;
      };
    };
}
