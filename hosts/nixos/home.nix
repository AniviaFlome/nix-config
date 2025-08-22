{ inputs, lib, config, pkgs, username, ...}:

{
   imports = [
    ./hm-imports.nix
   ];

  nixpkgs = {
    overlays = [
      inputs.nur.overlays.default
      inputs.firefox-addons.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
