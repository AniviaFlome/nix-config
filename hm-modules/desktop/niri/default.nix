{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.niri
    ./autostart.nix
    ./settings.nix
    ./keybinds.nix
    ../common/hypridle.nix
    ../common/noctalia.nix
  ];

  home.packages = with pkgs; [
    nirius
    xwayland-satellite
  ];
}
