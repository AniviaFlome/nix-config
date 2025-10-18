{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -U fish_greeting
    '';
    shellAliases = {
      ls = "eza --icons -a --group-directories-first";
      cd = "z";
      rm = "gio trash";
      man = "batman";
      cat = "bat";
    };
    shellInit = "\n       ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source\n    ";
  };
}
