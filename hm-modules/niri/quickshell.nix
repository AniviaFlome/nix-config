{ pkgs, ... }:

{
  home.packages = with pkgs; [
    quickshell
    kdePackages.qt5compat
    libsForQt5.qt5.qtgraphicaleffects
    cava
    gpu-screen-recorder
    material-symbols
    swww
    wallust
  ];

  xdg.configFile."quickshell" = {
    enable = true;
    source = ./quickshell;
    recursive = true;
  };
}
