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
  ];

  home.packages = with pkgs; [
    niriswitcher
    nirius
  ];
}
