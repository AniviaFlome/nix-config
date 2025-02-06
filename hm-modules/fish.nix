{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
    '';
    shellAliases = {
      ls="eza --icons -a --group-directories-first";
      cd="z";
    };
    shellInit = "
       ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    ";
  };
}
