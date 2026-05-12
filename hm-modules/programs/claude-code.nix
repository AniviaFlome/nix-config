let
  aiCommon = import ../misc/common/ai-common.nix;
in
{
  programs.claude-code = {
    enable = true;
    enableMcpIntegration = true;
    inherit (aiCommon) commands;
    inherit (aiCommon) skills;
    settings = {

    };
  };
}
