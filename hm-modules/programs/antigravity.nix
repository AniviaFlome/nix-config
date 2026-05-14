{
  pkgs,
  ide-font,
  ...
}:
{
  programs.antigravity = {
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
        ms-python.python
      ];
      userSettings = {
        "editor.fontFamily" = "'${ide-font}', 'monospace', monospace";
        "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };
  };
}
