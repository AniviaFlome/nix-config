{
  inputs,
  ...
}:
{
  imports = [ inputs.steam-config-nix.homeModules.default ];

  programs.steam.config = {
    enable = true;
    closeSteam = true;
    defaultCompatTool = "GE-Proton";

    apps = {
      sea-of-thieves = {
        id = 1091500;
        launchOptions = "gamemoderun %command%";
      };
    };
  };
}
