{ inputs, pkgs, ... }:

# let
#   hypr = inputs.hyprland.packages.${pkgs.system};
# in

{
  imports = [ inputs.illogical-impulse.homeManagerModules.default ];

  illogical-impulse = {
    # Enable Dotfiles
    enable = true;
    hyprland = {
      # Monitor preference
      monitor = [ ",preferred,auto,1" ];
      # Use cusomize hyprland packages
#       package = hypr.hyprland;
#       xdgPortalPackage = hypr.xdg-desktop-portal-hyprland;
      # Set NIXOS_OZONE_WL=1
      ozoneWayland.enable = true;
    };
    theme = {
      # Customize Cursors,
      # the following config is the default config
      # if you don't set.
      cursor = {
        package = with pkgs; catppuccin-cursors.mochaMauve;
        theme = "catppuccin-mocha-mauve-cursors";
      };
    };
    # Use custom ags package, the following package is the default.
    # agsPackage = ags.packages.${pkgs.system}.default.override {
    #   extraPackages = with pkgs; [
    #     gtksourceview
    #     gtksourceview4
    #     webkitgtk
    #     webp-pixbuf-loader
    #     ydotool
    #   ];
    # };
  };
}
