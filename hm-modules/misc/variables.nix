{ inputs, ... }:

{
  _module.args = {
    wallpaper = builtins.toPath ../theme/wallpaper/wallpaper.png;
  };

  home.sessionVariables = {
    XDG_UTILS_DEFAULT_BROWSER = "zen";
    XDG_UTILS_DEFAULT_TERMINAL = "kitty";
    XDG_UTILS_DEFAULT_FILE_MANAGER = "dolphin";
    BROWSER = "$XDG_UTILS_DEFAULT_BROWSER";
    FILE = "$XDG_UTILS_DEFAULT_FILE_MANAGER";
    TERMINAL = "$XDG_UTILS_DEFAULT_TERMINAL";
    IDE_FONT = "Cascadia Code";
    EDITOR = "micro";
    NIXPKGS_ALLOW_UNFREE = "1";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
  };
}
