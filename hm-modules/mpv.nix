{ catppuccin, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    catppuccin = {
      enable = true;
    };
    scripts = with pkgs; [
      mpvScripts.mpris
      mpvScripts.mpvacious
    ];
  };
}
