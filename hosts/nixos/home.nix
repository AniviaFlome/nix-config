{ inputs, lib, config, pkgs, username, ...}:

{
   imports = [
    ./hm-imports.nix
   ];

  nixpkgs = {
    overlays = [ inputs.nur.overlay ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "spicetify-Comfy"
      ];
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
