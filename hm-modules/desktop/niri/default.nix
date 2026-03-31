{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    ./autostart.nix
    ./keybinds.nix
    ./settings.nix
    ./scripts
    ../common/dms
  ];

  home.packages = with pkgs; [
    nirius
    xwayland-satellite
  ];
}
