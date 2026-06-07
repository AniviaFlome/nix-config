let
  aiCommon = import ./ai-common.nix;
in
{
  flake.modules.homeManager.opencode =
    { pkgs, ... }:
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
    };
}
