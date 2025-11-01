{
  pkgs,
  ...
}:
let
  catppuccin-gtk-override = pkgs.catppuccin-gtk.override {
    variant = "mocha";
    accents = [ "mauve" ];
    size = "standard";
  };
in
{
  imports = [ ./catppuccin.nix ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = with pkgs; catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors";
    size = 24;
  };

  gtk = {
    enable = true;
    gtk2.force = true;
    theme = {
      package = catppuccin-gtk-override;
      name = "catppuccin-mocha-mauve-standard";
    };
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    gnome-icon-theme
    hicolor-icon-theme
    kdePackages.qt6ct
  ];
}
