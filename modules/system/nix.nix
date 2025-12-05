{
  config,
  inputs,
  pkgs,
  ...
}:
{
  nix = {
    optimise.automatic = true;
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://install.determinate.systems"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://ezkea.cachix.org"
      ];
      trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
      ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes pipe-operators
      builders-use-substitutes = true
      !include ${config.sops.secrets."nix-access-token".path}
      eval-cores = 2
    '';
  };

  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.antigravity-nix.overlays.default
      inputs.nix-bwrapper.overlays.default
      (final: prev: {
        stable = import inputs.nixpkgs-stable {
          inherit (final.stdenv.hostPlatform) system;
        };
        kdePackages = prev.kdePackages // {
          plasma-workspace =
            let
              basePkg = prev.kdePackages.plasma-workspace;
              # a helper package that merges all the XDG_DATA_DIRS into a single directory
              xdgdataPkg = pkgs.stdenv.mkDerivation {
                name = "${basePkg.name}-xdgdata";
                buildInputs = [ basePkg ];
                dontUnpack = true;
                dontFixup = true;
                dontWrapQtApps = true;
                installPhase = ''
                  mkdir -p $out/share
                  ( IFS=:
                    for DIR in $XDG_DATA_DIRS; do
                      if [[ -d "$DIR" ]]; then
                        cp -r $DIR/. $out/share/
                        chmod -R u+w $out/share
                      fi
                    done
                  )
                '';
              };
              # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
              # script and instead inject the path of the above helper package
              derivedPkg = basePkg.overrideAttrs {
                preFixup = ''
                  for index in "''${!qtWrapperArgs[@]}"; do
                    if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                      unset -v "qtWrapperArgs[$((index+0))]"
                      unset -v "qtWrapperArgs[$((index+1))]"
                      unset -v "qtWrapperArgs[$((index+2))]"
                      unset -v "qtWrapperArgs[$((index+3))]"
                    fi
                  done
                  qtWrapperArgs=("''${qtWrapperArgs[@]}")
                  qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                  qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                '';
              };
            in
            derivedPkg;
        };
      })
    ];
    config = {
      allowUnfree = true;
    };
  };
}
