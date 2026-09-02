{
  pkgs,
  ...
}:
{
  xdg = {
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;

    portal = {
      enable = true;
      xdgOpenUsePortal = false;
      wlr.enable = true;
      config = {
        common = {
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
        niri = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;
}
