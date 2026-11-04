{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.steam-config-nix.homeModules.default ];

  programs.steam = {
    config = {
      enable = true;
      onSteamRunning = "wait";
      defaultCompatTool = "dwproton";
      apps = {
        "1091500" = {
          name = "Sea of Thieves";
          rawLaunchOptions = "gamemoderun %command%";
        };
        "570" = {
          name = "Dota 2";
          rawLaunchOptions = "gamemoderun %command% -novid -nojoy";
        };
      };
    };
  };

  programs.steam-compat-tools.enable = true;

  home.packages = with pkgs; [
    dota2-rpc-client
  ];
}
