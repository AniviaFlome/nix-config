{
  config,
  inputs,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      accept-flake-config = true;
      auto-optimise-store = true;
      experimental-features = [
        "cgroups"
        "flakes"
        "nix-command"
        "pipe-operator"
      ];
      extra-substituters = [
        "https://aniviaflome-nix-repository.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://cache.numtide.com"
        "https://kopuz.cachix.org"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "aniviaflome-nix-repository.cachix.org-1:P+CE5AN1cNlYCvfAr/8xbKpD3MjdL1ZL9OiA5HJSBBo="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      extra-trusted-users = [
        "@wheel"
      ];
    };
    extraOptions = ''
      !include ${config.sops.secrets."nix-access-token".path}
      builders-use-substitutes = true
      experimental-features = cgroups flakes nix-command pipe-operator
      show-trace = true
      use-cgroups = true
      use-xdg-base-directories = true
      warn-dirty = false
    '';
  };

  nixpkgs = {
    overlays = import ../../overlays { inherit inputs; };
    config = {
      allowUnfree = true;
    };
  };
}
