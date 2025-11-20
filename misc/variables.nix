{
  lib,
  ...
}:
{
  _module.args = {
    audio = "mpv";
    audio-desktop = "mpv.desktop";
    browser = "zen-beta";
    browser-desktop = "zen-beta.desktop";
    ebook = "calibre";
    ebook-desktop = "calibre.desktop";
    editor = "zeditor";
    editor-desktop = "dev.zed.Zed.desktop";
    term-editor = "micro";
    file = "dolphin";
    file-desktop = "org.kde.dolphin.desktop";
    font = "Noto Sans";
    font-fixed = "Hack";
    font-size = "10";
    image = "gwenview";
    image-desktop = "org.kde.gwenview.desktop";
    launcher = "vicinae open";
    mail = "thunderbird";
    mail-desktop = "thunderbird.desktop";
    office = "onlyoffice-desktopeditor";
    office-desktop = "onlyoffice-desktopeditors.desktop";
    terminal = "kitty";
    terminal-desktop = "kitty.desktop";
    torrent = "qbittorrent";
    torrent-desktop = "qbittorrent.desktop";
    ide-font = "Cascadia Code";
    username = "aniviaflome";
    wallpaper = ./. + "/../hm-modules/theme/wallpaper/wallpaper.png";
    video = "mpv";
    video-desktop = "mpv.desktop";

    desktopFile =
      pkg:
      let
        appsDir = "${pkg}/share/applications";
      in
      lib.findFirst (f: lib.hasSuffix ".desktop" f) null (
        lib.mapAttrsToList (name: _: "${appsDir}/${name}") (
          lib.filterAttrs (_: t: t == "regular") (builtins.readDir appsDir)
        )
      );
  };
}
