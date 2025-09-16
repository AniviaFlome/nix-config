{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      package = with pkgs; jetbrains-mono;
      name = "Jetbrains Mono";
    };
    settings = {
      confirm_os_window_close = -1;
      remember_window_size = "no";
      initial_window_width = "90c";
      initial_window_height = "24c";
    };
  };
}
