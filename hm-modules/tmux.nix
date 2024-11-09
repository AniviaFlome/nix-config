{ catppuccin, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    catppuccin.enable = true;
    clock24 = true;
    terminal = "screen-256color";
    escapeTime = 0;
    extraConfig = ''
set -g history-limit 50000
set -g display-time 4000
set -g status-interval 5
set -g default-terminal "screen-256color"
set -g status-keys emacs
set -g focus-events on
setw -g aggressive-resize on
set -s escape-time 0
# Keybindings
bind C-p previous-window
bind C-n next-window
    '';
  };
}
