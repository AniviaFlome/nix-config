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
    extraPackages = with pkgs; [
      rtk
    ];
    inherit (aiCommon) commands;
    inherit (aiCommon) context;
    inherit (aiCommon) skills;
    settings = {
      plugin = [
        "opencode-vibeguard"
        "openrtk"
        "superpowers@git+https://github.com/obra/superpowers.git"
        "@prevalentware/opencode-goal-plugin"
      ];
    };
  };

  home.packages = with pkgs; [
    opencode-desktop
    opencode-claude-auth
  ];
}
