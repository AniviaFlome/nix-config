{ inputs, ... }:

{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";

    atuin.enable = true;
    bat.enable = true;
    fish.enable = true;
    kitty.enable = true;
    lazygit.enable = true;
    lsd.enable = true;
    mangohud.enable = true;
    micro.enable = true;
    mpv.enable = true;
#     qutebrowser = "catppuccin.enable";
    obs.enable = true;
    starship.enable = true;
    thunderbird.enable = true;
    tmux.enable = true;
    vesktop.enable = true;
    zathura.enable = true;
  };
}
