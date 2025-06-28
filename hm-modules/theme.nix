{ pkgs, config, ... }:

{
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = with pkgs; catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
    size = 18;
  };

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
      package = with pkgs; catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 18;
    };
  };
}
