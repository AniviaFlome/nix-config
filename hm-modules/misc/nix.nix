{
  config,
  inputs,
  osConfig,
  pkgs,
  ...
}:
{
  nix = {
    package = osConfig.nix.package or pkgs.nix;
    extraOptions = ''
      !include ${config.sops.secrets."nix-access-token".path}
    '';
  };

  nixpkgs = {
    overlays = import ../../overlays { inherit inputs; };
    config = {
      allowUnfree = true;
    };
  };
}
