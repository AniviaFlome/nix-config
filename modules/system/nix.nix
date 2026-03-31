{
  config,
  inputs,
  ...
}:
{
  nix = {
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://aniviaflome-nix-repository.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://cache.numtide.com"
        "https://ezkea.cachix.org"
        "https://hyprland.cachix.org"
        "https://install.determinate.systems"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "aniviaflome-nix-repository.cachix.org-1:P+CE5AN1cNlYCvfAr/8xbKpD3MjdL1ZL9OiA5HJSBBo="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    extraOptions = ''
      !include ${config.sops.secrets."nix-access-token".path}
      builders-use-substitutes = true
      experimental-features = nix-command flakes pipe-operators
      eval-cores = 2
    '';
  };

  nixpkgs = {
    overlays = import ../../overlays { inherit inputs; };
    config = {
      allowUnfree = true;
    };
  };
}
