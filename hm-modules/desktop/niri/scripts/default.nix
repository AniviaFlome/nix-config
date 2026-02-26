{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (writeScriptBin "niri-dmenu" (builtins.readFile ./niri_parse_keybinds.py))
    libnotify
  ];
}
