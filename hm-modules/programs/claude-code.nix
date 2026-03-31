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
    enableMcpIntegration = true;
    commands = aiCommon.commands;
    skills = aiCommon.skills;
    settings = {

    };
  };

  home.packages = with pkgs; [ llm-agents.claudebox ];
}
