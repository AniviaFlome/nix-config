{
  flake.modules.nixos.xorg = {
    services.xserver.enable = true;
  };
}
