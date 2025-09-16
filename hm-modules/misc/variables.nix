{ inputs, ... }:

{
  _module.args = {
    browser = "zen-browser";
    file = "dolphin";
    music = "spotify";
    terminal = "kitty";
    wallpaper = builtins.toPath ../theme/wallpaper/wallpaper.png;
  };

  home.sessionVariables = {
    EDITOR = "micro";
    NIXPKGS_ALLOW_UNFREE = "1";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
  };
}
