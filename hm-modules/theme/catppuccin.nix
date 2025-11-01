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
    kvantum.enable = false;
    lazygit.enable = true;
    lsd.enable = true;
    mangohud.enable = true;
    micro.enable = true;
    mpv.enable = true;
    nvim.enable = true;
    qutebrowser.enable = true;
    obs.enable = true;
    starship.enable = true;
    thunderbird.enable = true;
    tmux.enable = true;
    vesktop.enable = true;
    vscode.profiles.default = {
      enable = true;
      icons.enable = true;
    };
    zed.enable = true;
    zathura.enable = true;
  };
}
