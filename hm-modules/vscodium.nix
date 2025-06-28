{ pkgs, lib, ... }:

{
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; lib.mkForce [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      continue.continue
      formulahendry.code-runner
      jnoortheen.nix-ide
    ];
  };
}
