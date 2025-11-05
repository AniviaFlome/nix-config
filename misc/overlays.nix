{ inputs }:

{

  inputs.nur.overlays.default
  inputs.firefox-addons.overlays.default
  stable = final: _: {
    stable = import self.inputs.nixpkgs-stable {
      inherit (final) system;
    };
  };
}
