{
  pkgs,
  ide-font,
  ...
}:
{
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium-fhs;
    profiles.default = {
      enableMcpIntegration = true;
      extensions = with pkgs.vscode-extensions; [
        alefragnani.project-manager
        editorconfig.editorconfig
        esbenp.prettier-vscode
        formulahendry.code-runner
        github.copilot
        jnoortheen.nix-ide
        ms-python.python
      ];
      userSettings = {
        "editor.fontFamily" = "'${ide-font}', 'monospace', monospace";
      };
    };
  };
}
