{
  flake.modules.homeManager.bash = {
    programs.bash = {
      enable = true;
      historySize = 4000;
    };
  };
}
