{
  browser,
  file,
  term-editor,
  terminal,
  ...
}:
{
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
