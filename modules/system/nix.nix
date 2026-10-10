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
      substituters = [
        "https://aniviaflome-nix-repository.cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://cache.nixos-cuda.org"
        "https://kopuz.cachix.org"
        "https://niri-epireyn.cachix.org"
        "https://nix-community.cachix.org"
        "https://noctalia.cachix.org"
        "https://numtide.cachix.org"
      ];
      trusted-public-keys = [
        "aniviaflome-nix-repository.cachix.org-1:P+CE5AN1cNlYCvfAr/8xbKpD3MjdL1ZL9OiA5HJSBBo="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "kopuz.cachix.org-1:J2X3AnAYhKTJW5S3aCLoA1ckonQXVNZMQvhZA0YAufw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    extraOptions = ''
      !include ${config.sops.secrets."nix-access-token".path}
      builders-use-substitutes = true
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
