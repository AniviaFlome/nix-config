{
  inputs,
  ...
}:
[
  inputs.antigravity-nix.overlays.default
  inputs.firefox-addons.overlays.default
  inputs.nix-bwrapper.overlays.default
  inputs.nix-repository.overlays.default
  inputs.nur.overlays.default
  (final: _prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config = {
        allowUnfree = true;
      };
    };
  })
]
