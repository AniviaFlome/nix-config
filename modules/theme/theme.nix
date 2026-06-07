let
  catppuccin-gtk-override =
    pkgs:
    pkgs.catppuccin-gtk.override {
      variant = "mocha";
      accents = [ "mauve" ];
      size = "standard";
    };
in
{
  flake.modules.homeManager.theme =
    { config, pkgs, ... }:
    let
      gtk-override = catppuccin-gtk-override pkgs;
    in
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "catppuccin-mocha-mauve-cursors";
        size = 24;
      };

      gtk = {
        enable = true;
        gtk2.force = true;
        colorScheme = "dark";
        theme = {
          package = gtk-override;
          name = "catppuccin-mocha-mauve-standard";
        };
        gtk4.theme = config.gtk.theme;
      };

      home.file = {
        "${config.xdg.dataHome}/themes/catppuccin-mocha-mauve-standard".source =
          "${gtk-override}/share/themes/catppuccin-mocha-mauve-standard";
      };

      qt = {
        enable = true;
        style.name = "kde";
        platformTheme.name = "kde";
      };

      home.packages = with pkgs; [
        adwaita-icon-theme
        gnome-icon-theme
        hicolor-icon-theme
      ];
    };
}
