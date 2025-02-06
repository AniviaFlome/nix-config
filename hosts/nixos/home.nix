{ inputs, lib, config, pkgs, username, ...}:

{
   imports = [
    ./hm-imports.nix
   ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # DO NOT CHANGE THIS
  home.stateVersion = "23.05";
}
