let
  aiCommon = import ../misc/common/ai-common.nix;
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    commands = aiCommon.commands;
    skills = aiCommon.skills;
    settings = {

    };
  };
}
