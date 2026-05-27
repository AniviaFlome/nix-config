{
  pkgs,
  ...
}:
let
  aiCommon = import ../misc/common/ai-common.nix;
in
{
  programs.opencode = {
    enable = true;
    enableMcpIntegration = true;
    inherit (aiCommon) commands;
    inherit (aiCommon) skills;
    settings = {
      plugin = [
        "opencode-vibeguard"
        "rtk"
      ];
    };
  };

  home.packages = with pkgs; [
    opencode-desktop
    opencode-claude-auth
  ];
}
