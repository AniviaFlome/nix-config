{ inputs, lib, config, pkgs, username, ...}:

{
   imports = [
    ./hm-imports.nix
   ];

  nixpkgs = {
    overlays = [ inputs.nur.overlay ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  xdg.configFile."/nixpkgs/config.nix".text = ''
    allowUnfree = true;
  '';

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
