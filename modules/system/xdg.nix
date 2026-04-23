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
          default = [
            "kde"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
    };
  };

  services.gnome.gnome-keyring.enable = true;
}
