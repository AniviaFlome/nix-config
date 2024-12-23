{ catppuccin, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      mpvacious
    ];
    config = {
      hr-seek = "yes";
      keep-open = "yes";
    };
  };
}
