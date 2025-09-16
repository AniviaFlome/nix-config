{ inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.config
    ./autostart.nix
    ./extra.nix
    ./settings.nix
    ./keybinds.nix
  ];
}
