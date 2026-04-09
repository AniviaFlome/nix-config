{
  pkgs,
  ...
}:
{
  nix.package = pkgs.lixPackageSets.stable.lix;

  nixpkgs.overlays = [
    (_final: prev: {
      nixpkgs-review = prev.nixpkgs-review.override { nix = prev.lixPackageSets.stable.lix; };
      nix-eval-jobs = prev.nix-eval-jobs.override { nix = prev.lixPackageSets.stable.lix; };
      nix-fast-build = prev.nix-fast-build.override { nix = prev.lixPackageSets.stable.lix; };
      colmena = prev.colmena.override { nix = prev.lixPackageSets.stable.lix; };
    })
  ];
}
