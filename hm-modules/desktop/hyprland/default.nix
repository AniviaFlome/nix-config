{
  pkgs,
  ...
}:
{
  imports = [
    ./autostart.nix
    ./keybinds.nix
    ./settings.nix
    ../common/hypridle.nix
    ../common/dms
    ../common/shell-switcher.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    xwayland.enable = true;
    plugins = [

    ];
  };

  home.packages = with pkgs; [
    grimblast
    hyprland-qt-support
  ];
}
