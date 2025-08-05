{ pkgs, config, ... }:

let
  catppuccin-gtk-override = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = [ "mauve" ];
    size = "standard";
  };
in

{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
    size = 18;
  };

  gtk = {
    enable = true;
    theme = {
      package = catppuccin-gtk-override;
      name = "catppuccin-mocha-mauve-standard";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 18;
    };
  };
}
