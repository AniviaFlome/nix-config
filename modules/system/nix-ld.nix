{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
bzip2
glib
glibc
gtk3
libgcc
libepoxy
openssl
    ];
  };
}
