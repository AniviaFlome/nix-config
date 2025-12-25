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
      colors = {
        border = "#fae280";
        song_title = "#fae280";
        album = "#26a0a1";
        artist = "#d67751";
        border_title = "#8193af";
        progress_filled = "#26a0a1";
        progress_empty = "#1b1d0e";
        paused = "#e16a7c";
        playing = "#e16a7c";
        stopped = "#e16a7c";
        time_separator = "#e16a7c";
        time_duration = "#e16a7c";
        time_elapsed = "#e16a7c";
        queue_selected_highlight = "#b18a4a";
        queue_selected_text = "#1b1d0e";
        queue_album = "#26a0a1";
        queue_song_title = "#fae280";
        queue_artist = "#d67751";
        queue_position = "#e16a7c";
        queue_duration = "#e16a7c";
        top_accent = "#e16a7c";
        volume = "#26a0a1";
        volume_empty = "#1b1d0e";
        mode = "#fae280";
        track_duration = "#e16a7c";
      };
      pipewire = {
        bit_perfect_enabled = true;
      };
    };
  };
}
