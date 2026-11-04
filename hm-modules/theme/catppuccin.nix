{
  inputs,
  ...
}:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    enable = true;
    autoEnable = true;
    cache.enable = false;
    flavor = "mocha";
    accent = "mauve";

    cursors.enable = false;
    atuin.enable = true;
    bat.enable = true;
    fish.enable = true;
    gtk.icon.enable = false;
    helix.enable = true;
    hyprlock.enable = false;
    kitty.enable = true;
    kvantum.enable = false;
    lazygit.enable = true;
    lsd.enable = true;
    mangohud.enable = true;
    micro.enable = true;
    mpv.enable = true;
    nvim.enable = true;
    # catppuccin/nix still writes programs.opencode.tui (tui.json),
    # which OpenCode 2 ignores in favor of cli.json.
    # Theme is managed via programs.opencode.cli in programs/opencode.nix.
    opencode.enable = false;
    qutebrowser.enable = true;
    obs.enable = true;
    starship.enable = true;
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
}
