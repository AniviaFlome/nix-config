{ inputs, outputs, pkgs, lib, ... }:

{
  home = {
    stateVersion = "22.11";
    homeDirectory = lib.mkDefault "/home/${username}";
    username = "${username}";

    packages = with pkgs; [

    ];
  };
}
