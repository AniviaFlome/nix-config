{ config, inputs, pkgs, ...}:

{
  nix = {
    package = with pkgs; nix;
    extraOptions = "
      !include ${config.sops.secrets."nix-access-token".path}
	  ";
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
