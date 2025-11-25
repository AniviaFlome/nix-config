{
  ide-font,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.konsole = {
    enable = true;
    defaultProfile = "Default";
    profiles = {
      Default = {
        name = "Default";
        colorScheme = "catppuccin-mocha";
        font = {
          name = ide-font;
          size = 11;
        };
      };
    };
  };

  xdg.dataFile."konsole/catppuccin-mocha.colorscheme".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/konsole/refs/heads/main/themes/catppuccin-mocha.colorscheme";
    hash = "sha256-apsWpYLpmBQdbZCNo7h6wXK3eB9HtBkoJ3P3DReAB28=";
  };
}
