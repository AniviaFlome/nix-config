{
  pkgs,
  ...
}:
{
  programs.micro = {
    enable = true;
    package = pkgs.micro-full;
    settings = {
      keymenu = true;
    };
  };

  home.sessionVariables = {
    MICRO_TRUECOLOR = "1";
  };
}
