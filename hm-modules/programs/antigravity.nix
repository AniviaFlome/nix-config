{
  ide-font,
  inputs,
  pkgs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix { inherit inputs; };
in
{
  programs.antigravity = {
    enable = true;
    package = pkgs.antigravity-ide-fhs;
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
        "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };
  };

  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
    inherit (aiCommon) commands;
    inherit (aiCommon) skills;
    settings = {

    };
  };
}
