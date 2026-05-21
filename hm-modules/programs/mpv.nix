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
      cheatsheet
      file-browser
      mpris
      mpv-subtitle-lines
      mpvacious
      skipsilence
      sponsorblock-minimal
      subtitle-sync
      quality-menu
      mpv-webm
      modernz
      occivink.seekTo
      reload
      webtorrent-mpv-hook
      whisper-subs
      youtube-chat
    ];
    scriptOpts = {
      chapterskip = {
        skip = "opening;ending;more;categories;previews-new";
      };
      modernz = {
        hover_effect_color = "#cba6f7";
        nibble_color = "#cba6f7";
        seekbarfg_color = "#cba6f7";
        seekbarbg_color = "#272836";
        seekbar_cache_color = "#6c7086";
        seek_handle_color = "#cba6f7";
        seek_handle_border_color = "#cba6f7";

        jump_amount = "3";
        jump_softrepeat = "no";
      };
      subs2srs = {
        enable_new_note_timer = "no";
      };
      webm = {
        output_directory = "${config.xdg.userDirs.videos}/mpv";
      };
      webtorrent = {
        path = "memory";
      };
    };
    config = {
      osc = "no";
      title-bar = "no";

      write-filename-in-watch-later-config = "yes";
      save-watch-history = "yes";

      alang = "en,jp,tr";
      slang = "tr,en";
      sub-auto = "fuzzy";
      volume = 100;

      window-maximized = "yes";
      hr-seek = "yes";
      keep-open = "yes";

      watch-later-options-remove = "sub-pos";

      profile = "high-quality";
      video-sync = "display-resample";
      interpolation = true;

      vo = "gpu-next";
      hwdec = "auto-safe";
      hwdec-codecs = "all";
      gpu-api = "vulkan";

      screenshot-dir = "${config.xdg.userDirs.pictures}/mpv";
      screenshot-format = "webp";
      screenshot-webp-lossless = "yes";
    };
    bindings = {
      "c" = "script-binding quality_menu/video_formats_toggle";
      "Alt+c" = "script-binding quality_menu/audio_formats_toggle";
      "Ctrl+f" = "script-binding subtitle_lines/list_subtitles";
      "Ctrl+F" = "script-binding subtitle_lines/list_secondary_subtitles";
      "ö" = "add speed -0.05";
      "ç" = "add speed 0.05";

      # Shaders
      "Ctrl+1" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
      "Ctrl+2" =
        ''no-osd change-list glsl-shaders set "${pkgs.adore}/2x_Adore_renarchi_fp32.onnx"; show-text "Adore fp32"'';
      "Ctrl+3" =
        ''no-osd change-list glsl-shaders set "${pkgs.adore}/2x_Adore_renarchi_fp16.onnx"; show-text "Adore fp16"'';
    };
  };

  home.packages = with pkgs; [
    ffsubsync
  ];
}
