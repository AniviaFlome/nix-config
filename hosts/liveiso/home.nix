{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ../../hm-modules/theme/default.nix
  ];

  home.packages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
  ];

  programs.plasma = {
    enable = true;
    workspace = {
      colorScheme = "CatppuccinMochaMauve";
      lookAndFeel = "Catppuccin-Mocha-Mauve";
      iconTheme = "breeze-dark";
    };
  };

  programs.fish.enable = true;

  home.stateVersion = "23.05";
}
