{
  flake.modules.homeManager.nix-hm =
    { config, lib, ... }:
    {
      nix.package = lib.mkDefault config.nix.package;
    };
}
