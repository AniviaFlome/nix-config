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
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
      ];
    };
  };
}
