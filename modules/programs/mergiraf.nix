{
  flake.modules.homeManager.mergiraf = {
    programs.mergiraf = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
