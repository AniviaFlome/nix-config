{
  pkgs,
  ...
}:
{
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    dolphin
    gwenview
    okular
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    kservice
    wallpaper-engine-plugin
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
  };
}
