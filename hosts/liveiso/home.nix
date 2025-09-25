{ inputs, outputs, pkgs, lib, username, ... }:

{
  imports = [
    ../../hm-modules/plasma.nix
    ../../hm-modules/firefox/default.nix
  ];

  home = {
    stateVersion = "22.11";
    homeDirectory = lib.mkDefault "/home/${username}";
    username = "${username}";

    packages = with pkgs; [

    ];
  };
}
