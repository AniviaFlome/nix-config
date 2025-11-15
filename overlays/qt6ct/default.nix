final: prev: {
  kdePackages = prev.kdePackages // {
    qt6ct = prev.kdePackages.qt6ct.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (final.fetchpatch {
          url = "file://${./qt6ct-shenanigans.patch}";
          sha256 = null;
        })
      ];
    });
  };
}
