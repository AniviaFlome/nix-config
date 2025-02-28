{ inputs, ... }:

{
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    bat.enable = true;
    brave.enable = true;
    fish.enable = true;
    kitty.enable = true;
    mpv.enable = true;
    obs.enable = true;
    starship.enable = true;
    tmux.enable = true;
    zathura.enable = true;
  };
}
