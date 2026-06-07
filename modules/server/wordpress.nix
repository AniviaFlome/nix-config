{
  flake.modules.nixos.wordpress = {
    services.wordpress.sites."localhost" = { };
  };
}
