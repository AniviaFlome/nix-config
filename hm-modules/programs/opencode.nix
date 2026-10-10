{
  pkgs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix { inherit pkgs; };
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    commands = aiCommon.commands // {
      impeccable = "${pkgs.impeccable}/share/opencode-commands/impeccable.md";
    };
    skills = aiCommon.skills // {
      impeccable = "${pkgs.impeccable}/share/skills/impeccable";
    };
    settings = {
      plugins = [
        "opencode-tps-meter"
        "opencode-wakelock"
        "opencode-goal-plugin"
      ];
    };
  };
}
