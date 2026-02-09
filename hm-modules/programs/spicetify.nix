{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      enable = true;
      windowManagerPatch = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        betterGenres
        hidePodcasts
        wikify
        volumePercentage
      ];
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
        newReleases
      ];
      theme = spicePkgs.themes.comfy;
      colorScheme = "catppuccin-mocha";
    };
}
