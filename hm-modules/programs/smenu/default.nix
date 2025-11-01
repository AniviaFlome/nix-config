{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ smenu ];

  xdg.configFile."smenu" = {
    source = ./smenu;
    recursive = true;
    force = true;
  };
}
