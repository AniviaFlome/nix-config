{
  pkgs,
  ide-font,
  lib,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        alefragnani.project-manager
        esbenp.prettier-vscode
        formulahendry.code-runner
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.fontFamily" = "'${ide-font}', 'monospace', monospace";
      };
    };
  };
}
