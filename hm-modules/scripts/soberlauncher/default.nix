{
  pkgs,
  ...
}:
let
  soberlauncherBin = pkgs.writers.writePython3Bin "soberlauncher" {
    libraries = with pkgs.python3Packages; [
      pyqt6
      requests
    ];
    doCheck = false;
  } (builtins.readFile ./soberlauncher.py);

  desktopItem = pkgs.makeDesktopItem {
    name = "soberlauncher";
    desktopName = "Sober Launcher";
    genericName = "Roblox Launcher";
    exec = "soberlauncher";
    icon = ./soberlauncher.svg;
    comment = "Sober Launcher";
    categories = [ "Game" ];
    terminal = false;
  };
in
{
  home.packages = with pkgs; [
    soberlauncherBin
    desktopItem
    xdotool
  ];
}
