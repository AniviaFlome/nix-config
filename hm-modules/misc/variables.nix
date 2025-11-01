{
  browser,
  file,
  term-editor,
  terminal,
  ...
}:
{
  _module.args = {
    audio = "mpv";
    browser = "zen-beta";
    editor = "zeditor";
    term-editor = "micro";
    file = "dolphin";
    image = "gwenview";
    mail = "thunderbird";
    office = "libreoffice";
    terminal = "kitty";
    ide-font = "Cascadia Code";
    wallpaper = ./. + "/../theme/wallpaper/wallpaper.png";
    video = "mpv";
  };

  home.sessionVariables = {
    XDG_UTILS_DEFAULT_BROWSER = "${browser}";
    XDG_UTILS_DEFAULT_TERMINAL = "${terminal}";
    XDG_UTILS_DEFAULT_FILE_MANAGER = "${file}";
    EDITOR = "${term-editor}";
    NIXPKGS_ALLOW_UNFREE = "1";
    PROTON_USE_NTSYNC = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };
}
