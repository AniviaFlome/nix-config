{ config, inputs, pkgs, ...}:

{
  nix = {
    package = with pkgs; nix;
  };

  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.firefox-addons.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
