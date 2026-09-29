{
  osConfig,
  lib,
  config,
  ...
}:
{
  nix = {
    package = lib.mkDefault osConfig.nix.package;
    extraOptions = ''
      !include ${config.sops.secrets."nix-access-token".path}
    '';
  };
}
