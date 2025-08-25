{ inputs, ... }:

{
  _module.args = {
    browser = "zen-browser";
    file = "dolphin";
    music = "spotify";
    screenshot = builtins.toPath ./scripts/screenshot.nix;
    terminal = "kitty";
    wallpaper = builtins.toPath ./hm-modules/wallpaper/wallpaper.png;
  };

  home.sessionVariables = {
    EDITOR = "nano";
    NIXPKGS_ALLOW_UNFREE = "1";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
  };
}
