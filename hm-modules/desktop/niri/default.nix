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
    ../common/hypridle.nix
    ../common/noctalia.nix
  ];

  home.packages = with pkgs; [
    nirius
    xwayland-satellite
  ];
}
