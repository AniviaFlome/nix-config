{
  config,
  inputs,
  ...
}:
{
  nix = {
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
