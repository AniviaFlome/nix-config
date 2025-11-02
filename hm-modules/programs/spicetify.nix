{
  inputs,
  system,
  ...
}:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
    in
    {
      enable = true;
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
      colorScheme = "rose-pine";
    };
}
