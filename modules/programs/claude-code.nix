let
  aiCommon = import ./ai-common.nix;
in
{
  flake.modules.homeManager.claude-code = {
    programs.claude-code = {
      enable = true;
      enableMcpIntegration = true;
      inherit (aiCommon) commands;
      inherit (aiCommon) skills;
      settings = {

      };
    };
  };
}
