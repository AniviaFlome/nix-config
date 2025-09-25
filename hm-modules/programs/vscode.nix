{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        formulahendry.code-runner
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.fontFamily" = "'$IDE_FONT', 'monospace', monospace";
        "workbench.colorTheme" =  "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
      };
    };
  };
}
