{ inputs, config, ... }:
let
  m = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = config.flake.variables // {
        inherit inputs;
      };
      users.${config.flake.variables.username}.imports = [
        m.pc
        m.antigravity
        m.atuin
        m.bash
        m.bat
        m.catppuccin
        m.claude-code
        m.difftastic
        m.direnv
        m.easyeffects
        m.fastfetch
        m.fish
        m.git
        m.kate
        m.kitty
        m.konsole
        m.ludusavi
        m.manual
        m.mcp
        m.mergiraf
        m.micro
        m.mime
        m.mpv
        m.niri
        m.nix-hm
        m.nix-index
        m.nix-webapps
        m.nixcord
        m.nushell
        m.nvf
        m.nyaa
        m.obs-studio
        m.opencode
        m.plasma
        m.qutebrowser
        m.ripgrep
        m.scripts
        m.scripts-secrets
        m.shell-aliases
        m.sldl
        m.spicetify
        m.sops
        m.spotify-player
        m.starship
        m.theme
        m.thunderbird
        m.tmenu
        m.variables
        m.xdg-hm
        m.zed
        m.zen-browser
        m.zoxide
      ];
    };
  };

  flake.modules.homeManager.pc =
    { username, ... }:
    {
      home = {
        inherit username;
        homeDirectory = "/home/${username}";
        stateVersion = "23.05";
      };
    };
}