{
  pkgs,
  ide-font,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = with pkgs; vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        alefragnani.project-manager
        editorconfig.editorconfig
        esbenp.prettier-vscode
        formulahendry.code-runner
        github.copilot
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.fontFamily" = "'${ide-font}', 'monospace', monospace";
      };
    };
  };
}
