{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    just
  ];
  shellHook = ''
    echo -e "\e[38;5;183mWelcome to my nix-config!\e[0m"
  '';
}
