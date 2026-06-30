{
  pkgs,
  ...
}:
{
  imports = [
    ./autostart.nix
    ./keybinds.nix
    ./settings.nix
    ../common/dms
    ../common/shell-switcher.nix
  ];

  home.packages = with pkgs; [
    nirius
    xwayland-satellite
  ];
}
