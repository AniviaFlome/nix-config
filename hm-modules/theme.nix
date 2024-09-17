{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      package = with pkgs; (catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "mauve" ];
        size = "standard";
      });
      name = "catppuccin-mocha-mauve-standard";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
    };
  };
}
