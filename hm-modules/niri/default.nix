{ pkgs, ... }:

{
  xdg.configFile."niri" = {
    source = ./niri;
    recursive = true;
  };
}
