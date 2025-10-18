{ config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autosub
      autosubsync-mpv
      chapterskip
      mpris
      mpvacious
      skipsilence
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
    bindings = { };
    scriptOpts = {
      chapterskip = {
        skip = "opening;ending;more;categories;previews-new";
      };
      modernz = {
        seekbarfg_color = "#CBA6F7";
        seekbarbg_color = "#272836";
        seekbar_cache_color = "#6C7086";
        jump_amount = "3";
        jump_softrepeat = "no";
      };
      webtorrent = {
        path = "memory";
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
