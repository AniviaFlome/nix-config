{
  osConfig,
  lib,
  ...
}:
{
  nix = {
    package = lib.mkDefault osConfig.nix.package;
  };
}
