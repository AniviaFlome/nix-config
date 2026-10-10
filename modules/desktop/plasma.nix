{
  pkgs,
  ...
}:
{
  services.desktopManager.plasma6.enable = true;

  programs.kde-pim = {
    enable = false;
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # keep-sorted start case=no
    discover
    elisa
    gwenview
    okular
    # keep-sorted end
  ];

  environment.systemPackages = with pkgs.kdePackages; [
    wallpaper-engine-plugin
  ];

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
