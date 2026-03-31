{
  config,
  ...
}:
{
  xdg = {
    portal = {
      config = {
        common = {
          default = "*";
        };
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
      extraConfig = {
        MISC = "${config.home.homeDirectory}/Random";
      };
    };
  };
}
