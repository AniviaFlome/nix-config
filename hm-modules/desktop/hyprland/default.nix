{
  pkgs,
  ...
}:
{
  imports = [
    ../common/dms
    ./autostart.nix
    ./keybinds.nix
    ./settings.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";
    plugins = [

    ];
  };

  programs.hyprland-qt-support = {
    enable = true;
  };

  home.packages = with pkgs; [
    grimblast
  ];
}
