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
    inherit (aiCommon) commands;
    inherit (aiCommon) skills;
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
