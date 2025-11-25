{
  config,
  inputs,
  lib,
  pkgs,
  term-editor,
  video,
  ...
}:
{
  home.packages = with pkgs; [
    inputs.yt-x.packages."${stdenv.hostPlatform.system}".default
    fzf
  ];

  xdg.configFile."yt-x/yt-x.conf" = {
    force = true;
    text = ''
      # loads the extension always
      # useful for defining changes and overides to the default behaviour
      # eg env,ui,functions
      # all file names in the extensions folder
      AUTO_LOADED_EXTENSIONS:

      # whether to show colors when printing ouput
      PRETTY_PRINT: true

      # your preferred editor for editing your config
      EDITOR: ${term-editor}

      # your preferred selector for the tui [fzf/rofi]
      PREFERRED_SELECTOR: fzf

      # the quality of the video when streaming with a player other than mpv
      VIDEO_QUALITY: 1080

      # whether to show previews [true/false]
      # its cool so enable it
      ENABLE_PREVIEW: true

      # what to use for rendering images in the terminal [chafa/icat]
      IMAGE_RENDERER: icat

      # whether to run mpv as a background process and prevent it from closing even if you terminate the program or terminal session
      DISOWN_STREAMING_PROCESS: true

      # whether to update the recent list kept locally [true/false]
      UPDATE_RECENT: true

      # whether to update the recent list kept locally [true/false]
      SEARCH_HISTORY: true

      # the number of recent videos to keep
      NO_OF_RECENT: 5

      # the player to use for streaming [mpv/vlc]
      PLAYER: ${video}

      # the browser to use to extract cookies from
      # this is used to by yt-dlp to access content that would require login
      PREFERRED_BROWSER: brave

      # the number of results to get from yt-dlp
      NO_OF_SEARCH_RESULTS: 30

      # the duration notifications stay on the screen
      NOTIFICATION_DURATION: 5

      # where your downloads will be stored
      DOWNLOAD_DIRECTORY: ${config.xdg.userDirs.videos}/Youtube

      # whether to check for updates [true/false]
      UPDATE_CHECK: false
    '';
  };

  home.sessionVariables =
    let
      # Catppuccin Mocha Palette
      colors = {
        base = "#1e1e2e";
        surface0 = "#313244"; # Used for selection background
        overlay0 = "#6c7086"; # Used for borders
        text = "#cdd6f4";
        accent = "#cba6f7"; # Primary Accent
      };
      themeOpts = lib.concatStringsSep " " [
        # Base and Text
        "--color=bg:${colors.base}"
        "--color=fg:${colors.text}"
        # Selection (Active Item)
        "--color=bg+:${colors.surface0}"
        "--color=fg+:${colors.text}"
        # UI Elements
        "--color=hl:${colors.accent}" # Highlighted substrings
        "--color=hl+:${colors.accent}" # Highlighted substrings (selected)
        "--color=info:${colors.accent}" # Info text
        "--color=marker:${colors.accent}" # Multi-select marker
        "--color=prompt:${colors.accent}" # Input prompt
        "--color=spinner:${colors.accent}" # Streaming spinner
        "--color=pointer:${colors.accent}" # Selection pointer
        "--color=header:${colors.accent}" # Header text
        "--color=label:${colors.accent}" # Border label
        # Borders
        "--color=border:${colors.overlay0}"
        "--color=query:${colors.text}"
        # Layout & Styling
        "--border='rounded'"
        "--border-label=''"
        "--preview-window='border-rounded'"
        "--prompt='> '"
        "--marker='>'"
        "--pointer='◆'"
        "--separator='─'"
        "--scrollbar='│'"
      ];
    in
    {
      YT_X_FZF_OPTS = themeOpts;
    };
}
