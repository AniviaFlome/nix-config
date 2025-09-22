{ config, inputs, self, pkgs-stable, ... }:

{
  nix = {
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://install.determinate.systems"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
    extraOptions = ''
     experimental-features = nix-command flakes
     builders-use-substitutes = true
     !include ${config.sops.secrets."nix-access-token".path}
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # Set up overlays to make stable packages available with unfree enabled
  nixpkgs.overlays = [
    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final) system;
        config.allowUnfree = true;
      };
    })
  ];
}
