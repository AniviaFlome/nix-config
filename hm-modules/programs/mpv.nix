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
      quality-menu
      mpv-cheatsheet
      mpv-webm
      modernz
      occivink.seekTo
      reload
      webtorrent-mpv-hook
      whisper-subs
      youtube-chat
    ];
    bindings = {
      "c" = "script-binding quality_menu/video_formats_toggle";
      "Alt+c" = "script-binding quality_menu/audio_formats_toggle";
      "Ctrl+p" = "script-binding mpv-playlistmanager/openmenu";
      "Ctrl+f" = "script-binding subtitle_lines/list_subtitles";
      "Ctrl+F" = "script-binding subtitle_lines/list_secondary_subtitles";
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
      webm = {
        output_directory = "${config.xdg.userDirs.videos}/mpv";
      };
      webtorrent = {
        path = "memory";
      };
    };
    config = {
      write-filename-in-watch-later-config = "yes";
      save-watch-history = "yes";

      alang = "jp,en,tr";
      slang = "tr,en";
      sub-auto = "fuzzy";
      volume = 100;

      window-maximized = "yes";
      hr-seek = "yes";
      keep-open = "yes";

      vo = "gpu-next";
      hwdec = "auto-safe";
      hwdec-codecs = "all";
      gpu-api = "vulkan";

      screenshot-dir = "${config.xdg.userDirs.pictures}/mpv";
      screenshot-format = "webp";
      screenshot-webp-lossless = "yes";
    };
  };

  home.packages = with pkgs; [
    ffsubsync
  ];
}
