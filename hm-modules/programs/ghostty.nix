{
  ide-font,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
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
