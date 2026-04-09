{
  config,
  inputs,
  osConfig,
  pkgs,
  lib,
  ...
}:
{
  nix = {
    package = lib.mkDefault (osConfig.nix.package or pkgs.nix);
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operator"
      ];
    };
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
