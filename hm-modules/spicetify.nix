{ inputs, pkgs, ... }:

{

  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify =
   let
     spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
   in
   {
     enable = true;
     enabledExtensions = with spicePkgs.extensions; [  # Special characters are sanitized out of extension names
       adblock
       betterGenres
       hidePodcasts
     ];
      enabledCustomApps= with spicePkgs.apps; [
        marketplace
        newReleases
    ];
     theme = spicePkgs.themes.comfy;
     colorScheme = "rose-pine";
   };
}
