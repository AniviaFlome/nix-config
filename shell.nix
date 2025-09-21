{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    just
  ];
  shellHook = ''
    echo "Welcome to my nix-config!"
  '';
}
