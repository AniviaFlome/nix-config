{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.mango.hmModules.mango
    ./autostart.nix
    ./keybinds.nix
    ./settings.nix
    ../common/dms
  ];

  wayland.windowManager.mango = {
    enable = true;
  };

  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    wlr-randr
  ];
}
