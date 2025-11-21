{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-webapps.homeManagerModules.default ];

  programs.webappManager = {
    enable = true;
    defaultBrowser = "zen";
    apps = {
      github = {
        url = "https://github.com";
        comment = "GitHub";
      };
    };
  };
}
