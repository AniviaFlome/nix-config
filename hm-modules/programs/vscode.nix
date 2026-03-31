{
  pkgs,
  ide-font,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.antigravity-fhs;
    profiles.default = {
      enableMcpIntegration = true;
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
