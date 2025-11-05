{
  ide-font,
  ...
}:
{
  programs.kitty = {
    enable = true;
    font = {
      name = ide-font;
    };
    settings = {
      confirm_os_window_close = -1;
      remember_window_size = "no";
      initial_window_width = "90c";
      initial_window_height = "24c";
    };
  };
}
