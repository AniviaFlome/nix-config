{
  inputs,
  ...
}:
[
  inputs.nur.overlays.default
  inputs.firefox-addons.overlays.default
  inputs.antigravity-nix.overlays.default
  inputs.nix-bwrapper.overlays.default
  inputs.nix-repository.overlays.default
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config = {
        allowUnfree = true;
      };
    };
    kdePackages = prev.kdePackages // {
      plasma-workspace =
        let
          basePkg = prev.kdePackages.plasma-workspace;
          # a helper package that merges all the XDG_DATA_DIRS into a single directory
          xdgdataPkg = final.stdenv.mkDerivation {
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
]
