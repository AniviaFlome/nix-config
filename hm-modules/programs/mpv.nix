{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autosubsync-mpv
      chapterskip
      mpris
      mpvacious
      sponsorblock-minimal
      occivink.seekTo
      quality-menu
      mpv-cheatsheet
      mpv-playlistmanager
      modernz
      reload
      webtorrent-mpv-hook
      youtube-chat
    ];
    bindings = {

    };
    scriptOpts = {
      modernz = {
        seekbarfg_color = "#CBA6F7";
        seekbarbg_color = "#272836";
        seekbar_cache_color = "#6C7086";
        jump_amount = "3";
        jump_softrepeat = "no";
      };
      chapterskip = {
        skip = "opening;ending;more;categories;previews-new";
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
