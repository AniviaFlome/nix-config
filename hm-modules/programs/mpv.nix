{
  config,
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autosubsync-mpv
      chapterskip
      mpris
      mpv-subtitle-lines
      mpvacious
      skipsilence
      sponsorblock-minimal
      subtitle-sync
      occivink.seekTo
      quality-menu
      mpv-cheatsheet
      mpv-playlistmanager
      modernz
      reload
      webtorrent-mpv-hook
      whisper-subs
      youtube-chat
    ];
    bindings = {
      "C" = "script-binding quality_menu/video_formats_toggle";
      "Alt+C" = "script-binding quality_menu/audio_formats_toggle";
    };
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
      window-maximized = "yes";
      hr-seek = "yes";
      keep-open = "yes";
      vo = "gpu-next";
      hwdec = "auto-safe";
      hwdec-codecs = "all";
      gpu-api = "vulkan";
      screenshot-dir = "${config.xdg.userDirs.pictures}/mpv";
      screenshot-format = "png";
    };
  };

  home.packages = with pkgs; [
    ffsubsync
  ];
}
