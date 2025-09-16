{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autosubsync-mpv
      mpris
      mpvacious
      sponsorblock
      occivink.seekTo
      quality-menu
      mpv-cheatsheet
      mpv-playlistmanager
      modernz
      reload
      webtorrent-mpv-hook
      youtube-upnext
    ];
    bindings = {
      "l" = "script-binding sponsorblock/set_segment";
      "Shift+l" = "script-binding sponsorblock/set_segment";
    };
    scriptOpts = {
      modernz = {
        seekbarfg_color= "#CBA6F7";
        jump_amount = "3";
        jump_softrepeat = "no";
      };
    };
    config = {
      hr-seek = "yes";
      keep-open = "yes";
      screenshot-dir = "${config.xdg.userDirs.pictures}";
      screenshot-format = "png";
    };
  };
}
