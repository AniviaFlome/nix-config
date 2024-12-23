{ inputs, lib, config, pkgs, username, ...}:

{
  imports = [ ./hm-imports.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;  # Workaround for https://github.com/nix-community/home-manager/issues/2942
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
