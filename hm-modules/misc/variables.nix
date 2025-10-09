{ browser, file, terminal, ... }:

{
  _module.args = {
    browser = "zen";
    file = "dolphin";
    terminal = "kitty";
    ide-font = "Cascadia Code";
    wallpaper = ./. + "/../theme/wallpaper/wallpaper.png";
  };

  home.sessionVariables = {
    XDG_UTILS_DEFAULT_BROWSER = "${browser}";
    XDG_UTILS_DEFAULT_TERMINAL = "${terminal}";
    XDG_UTILS_DEFAULT_FILE_MANAGER = "${file}";
    EDITOR = "micro";
    NIXPKGS_ALLOW_UNFREE = "1";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
  };
}
