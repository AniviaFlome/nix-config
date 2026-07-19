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
  ];

  home.packages = with pkgs; [
    nirius
    xwayland-satellite
  ];
}
