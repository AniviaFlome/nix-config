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
        seekbarfg_color = "#cba6f7";
        seekbarbg_color = "#272836";
        seekbar_cache_color = "#6c7086";
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
    bindings = {
      "c" = "script-binding quality_menu/video_formats_toggle";
      "Alt+c" = "script-binding quality_menu/audio_formats_toggle";
      "Ctrl+f" = "script-binding subtitle_lines/list_subtitles";
      "Ctrl+F" = "script-binding subtitle_lines/list_secondary_subtitles";
      "ö" = "add speed 0.05";
      "ç" = "add speed -0.05";

      # Shaders
      "Ctrl+1" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
      "Ctrl+2" =
        ''no-osd change-list glsl-shaders set "${pkgs.fallin}/Fallin_Soft.onnx"; show-text "Fallin: Soft"'';
      "Ctrl+3" =
        ''no-osd change-list glsl-shaders set "${pkgs.fallin}/Fallin_Strong.onnx"; show-text "Fallin: Strong"'';
      "Ctrl+4" =
        ''no-osd change-list glsl-shaders set "${pkgs.artcnn}/ArtCNN_C4F16.glsl"; show-text "ArtCNN: C4F16"'';
      "Ctrl+5" =
        ''no-osd change-list glsl-shaders set "${pkgs.artcnn}/ArtCNN_C4F16_DN.glsl"; show-text "ArtCNN: C4F16 Denoise"'';
      "Ctrl+6" =
        ''no-osd change-list glsl-shaders set "${pkgs.artcnn}/ArtCNN_C4F32.glsl"; show-text "ArtCNN: C4F32"'';
      "Ctrl+7" =
        ''no-osd change-list glsl-shaders set "${pkgs.artcnn}/ArtCNN_C4F32_DN.glsl"; show-text "ArtCNN: C4F32 Denoise"'';
      "Ctrl+8" =
        ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
      "Ctrl+9" =
        ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
      "Ctrl+0" =
        ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
      "Alt+8" =
        ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
      "Alt+9" =
        ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
      "Alt+0" =
        ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
    };
  };

  home.packages = with pkgs; [
    ffsubsync
  ];
}
