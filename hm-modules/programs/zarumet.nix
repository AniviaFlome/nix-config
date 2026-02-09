{
  inputs,
  ...
}:
{
  imports = [ inputs.zarumet.homeModules.default ];

  programs.zarumet = {
    enable = true;
    settings = {
      mpd = {
        address = "localhost:6600";
      };
      colors =
        let
          base = "#1e1e2e";
          surface0 = "#313244";
          overlay0 = "#6c7086";
          teal = "#94e2d5";
          peach = "#fab387";
          red = "#f38ba8";
          accent = "#cba6f7";
          background = base;
          secondary = teal;
          warning = red;
        in
        {
          border = accent;
          border_title = overlay0;
          top_accent = warning;
          mode = accent;
          song_title = accent;
          album = secondary;
          artist = peach;
          progress_filled = secondary;
          progress_empty = surface0;
          paused = warning;
          playing = warning;
          stopped = warning;
          time_separator = warning;
          time_duration = warning;
          time_elapsed = warning;
          track_duration = warning;
          queue_selected_highlight = accent;
          queue_selected_text = background;
          queue_album = secondary;
          queue_song_title = accent;
          queue_artist = peach;
          queue_position = warning;
          queue_duration = warning;
          volume = secondary;
          volume_empty = surface0;
        };
      pipewire = {
        bit_perfect_enabled = true;
      };
    };
  };
}
