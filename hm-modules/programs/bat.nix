{
  pkgs,
  ...
}:
{
  programs.bat = {
    enable = true;
  };

  home.packages = with pkgs; [
    bat-extras.core
  ];
}
