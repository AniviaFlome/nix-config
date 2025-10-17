{ pkgs, ... }:

{
  home.packages = with pkgs; [ nyaa ];
  
  xdg.configFile."nyaa" = {
    source = ./nyaa;
    recursive = true;
    force = true;
  }
}