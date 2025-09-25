{ inputs, outputs, pkgs, lib, username, ... }:

{
  home = {
    stateVersion = "22.11";
    homeDirectory = lib.mkDefault "/home/${username}";
    username = "${username}";

    packages = with pkgs; [

    ];
  };
}
