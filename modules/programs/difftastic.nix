{
  flake.modules.homeManager.difftastic = {
    programs.difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
    };
  };
}
