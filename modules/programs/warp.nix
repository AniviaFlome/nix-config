{
  flake.modules.nixos.warp = {
    services.cloudflare-warp.enable = true;
  };
}
