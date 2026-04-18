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
      trusted-users = [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://aniviaflome-nix-repository.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://cache.numtide.com"
        "https://rusic.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "aniviaflome-nix-repository.cachix.org-1:P+CE5AN1cNlYCvfAr/8xbKpD3MjdL1ZL9OiA5HJSBBo="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "rusic.cachix.org-1:WXMpGpamblLUiJtcoxBxGGGGwIcWxGPJBUxarLiqWmw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    extraOptions = ''
      !include ${config.sops.secrets."nix-access-token".path}
      builders-use-substitutes = true
      experimental-features = cgroups flakes nix-command
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
