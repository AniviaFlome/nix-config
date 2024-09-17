{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+t" = "new_tab";
      "ctrl+q" = "close_tab";
      "ctrl+enter" = "new_window";
      "ctrl+w" = "close_window";
      "ctrl+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
    };
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
    catppuccin.enable = true;
  };
}
