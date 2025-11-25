{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.niri.homeModules.config
    ./autostart.nix
    ./noctalia.nix
    ./settings.nix
    ./keybinds.nix
    ../hyprland/hypridle.nix
  ];

  home.packages = with pkgs; [
    nirius
    xwayland-satellite
  ];
}
