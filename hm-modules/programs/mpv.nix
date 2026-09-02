{
  config,
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      # keep-sorted start case=no
      autosubsync-mpv
      chapterskip
      file-browser
      keybind-visualizer
      modernz
      mpris
      mpv-subtitle-lines
      mpv-webm
      mpvacious
      occivink.seekTo
      quality-menu
      reload
      skipsilence
      sponsorblock-minimal
      sub-seek
      subtitle-sync
      subtitle-translate
      webtorrent-mpv-hook
      youtube-chat
      # keep-sorted end
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
      subtitle-translate = {
        provider = "google";
        word_provider = "cambridge";

        lang_from = "en";
        lang_to = "tr";

        position = "top-center";
        translation_background = "yes";
      };
    };
    config = {
      osc = "no";
      title-bar = "no";

      write-filename-in-watch-later-config = "yes";
      save-watch-history = "yes";

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
      "ö" = "add speed -0.05";
      "ç" = "add speed 0.05";

      "c" = "script-binding quality_menu/video_formats_toggle";
      "Alt+c" = "script-binding quality_menu/audio_formats_toggle";

      "Ctrl+f" = "script-binding subtitle_lines/list_subtitles";
      "Ctrl+F" = "script-binding subtitle_lines/list_secondary_subtitles";

      "F7" = "script-binding keybind-visualizer";
      "F8" = "script-binding sub-seek-list";

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
