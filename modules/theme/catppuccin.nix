{ inputs, ... }:
{
  flake.modules.nixos.catppuccin =
    { pkgs, ... }:
    {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];
      catppuccin = {
        enable = true;
        cache.enable = true;
        flavor = "mocha";
        accent = "mauve";
        limine.enable = true;
        sddm.enable = true;
        tty.enable = true;
      };
      environment.systemPackages = with pkgs; [
        catppuccin-cursors.mochaMauve
        catppuccin-qt5ct
      ];
    };

  flake.modules.homeManager.catppuccin = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      enable = true;
      autoEnable = true;
      cache.enable = true;
      flavor = "mocha";
      accent = "mauve";

      atuin.enable = true;
      bat.enable = true;
      fish.enable = true;
      hyprlock.enable = false;
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
      spotify-player.enable = true;
      thunderbird.enable = true;
      tmux.enable = true;
      vesktop.enable = true;
      vicinae.enable = true;
      vscode.profiles.default = {
        enable = true;
        icons.enable = true;
      };
      zathura.enable = true;
      zed.enable = true;
      zellij.enable = true;
    };
  };
}
