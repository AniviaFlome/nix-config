{
  pkgs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix { inherit pkgs; };
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
