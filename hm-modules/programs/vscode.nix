{ pkgs, ide-font, lib, ... }:

{
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; lib.mkForce [
        alefragnani.project-manager
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        esbenp.prettier-vscode
        formulahendry.code-runner
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.fontFamily" = "'${ide-font}', 'monospace', monospace";
        "workbench.colorTheme" =  "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
      };
    };
  };
}
