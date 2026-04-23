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
        aiBandBlocker
        betterGenres
        extendedCopy
        hidePodcasts
        volumePercentage
      ];
      enabledCustomApps = with spicePkgs.apps; [
        historyInSidebar
        marketplace
        newReleases
      ];
      theme = spicePkgs.themes.comfy;
      colorScheme = "custom";
      customColorScheme = {
        text = "cdd6f4";
        subtext = "bac2de";
        main = "181825";
        main-elevated = "232432";
        main-transition = "181825";
        highlight = "333645";
        highlight-elevated = "292a38";
        sidebar = "1e1e2e";
        player = "181825";
        card = "45475a";
        shadow = "585b70";
        selected-row = "bac2de";
        button = "cba6f7";
        button-active = "cba6f7";
        button-disabled = "45475a";
        tab-active = "313244";
        notification = "cba6f7";
        notification-error = "f38ba8";
        misc = "585b70";
        play-button = "f5c2e7";
        play-button-active = "F2cdcd";
        progress-fg = "89dceb";
        progress-bg = "45475a";
        heart = "fab387";
        pagelink-active = "ffffff";
        radio-btn-active = "cba6f7";
      };
    };
}
