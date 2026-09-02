{
  pkgs,
  inputs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix { inherit inputs; };
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    inherit (aiCommon) commands;
    inherit (aiCommon) context;
    inherit (aiCommon) skills;
    settings = {
      plugin = [
        "opencode-auto-resume"
        "@prevalentware/opencode-goal-plugin"
      ];
    };
  };

  home.packages = with pkgs; [
    opencode-desktop
  ];
}
