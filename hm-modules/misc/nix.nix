{
  config,
  inputs,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nix;
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
