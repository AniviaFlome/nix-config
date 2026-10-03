{
  pkgs,
  inputs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix { inherit inputs pkgs; };
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    commands = aiCommon.commands // {
      impeccable = "${inputs.impeccable}/.opencode/commands/impeccable.md";
    };
    skills = aiCommon.skills // {
      impeccable = "${inputs.impeccable}/.opencode/skills/impeccable";
    };
    settings = {
      plugins = [
        "opencode-tps-meter"
        "opencode-wakelock"
        "@prevalentware/opencode-goal-plugin"
        "@tarquinen/opencode-dcp"
      ];
    };
  };
}
