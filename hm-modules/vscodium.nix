{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      formulahendry.code-runner
      jnoortheen.nix-ide
    ];
  };
}
