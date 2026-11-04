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
    mutableSettings = false;
    inherit (aiCommon) commands skills;
    cli = {
      prompt = {
        editor = true;
      };
    };
    settings = {
      autoupdate = false;
      plugins = [
        "opencode-tps-meter"
        "opencode-wakelock"
      ];
      experimental = {
        background_compaction = true;
      };
    };
  };
}
