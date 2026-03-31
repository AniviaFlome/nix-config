{
  ide-font,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      font-family = ide-font;
      theme = "catppuccin-mocha";
      background-opacity = "1";
    };
  };
}
