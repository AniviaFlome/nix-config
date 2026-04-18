{
  pkgs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix;
in
{
  programs.claude-code = {
    enable = true;
    package = pkgs.claude-code-bin;
    enableMcpIntegration = true;
    inherit (aiCommon) commands;
    inherit (aiCommon) skills;
    settings = {

    };
  };
}
