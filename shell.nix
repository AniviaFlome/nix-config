{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    just
    git
  ];
  shellHook = ''
    echo -e "\e[38;5;183mWelcome to my nix-config!\e[0m"
  '';
}
