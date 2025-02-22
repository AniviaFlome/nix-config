{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs;[
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
