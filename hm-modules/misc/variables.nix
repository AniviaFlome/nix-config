{ browser, editor, file, terminal, ... }:

{
  _module.args = {
    audio = "mpv";
    browser = "zen-beta";
    editor = "codium";
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
    EDITOR = "${editor}";
    NIXPKGS_ALLOW_UNFREE = "1";
    PROTON_USE_NTSYNC= "1";
    _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
    CLUTTER_BACKEND = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };
}
