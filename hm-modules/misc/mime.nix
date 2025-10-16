{ pkgs, lib, audio, browser, editor, file, image, mail, office, terminal, video, ... }:

with lib;
let
  defaultApps = {
    text = [ "${editor}.desktop" ];
    image = [ "${image}.desktop" ];
    audio = [ "${audio}.desktop" ];
    video = [ "${audio}.desktop" ];
    directory = [ "org.kde.dolphin.desktop" ];
    mail = [ "${mail}.desktop" ];
    calendar = [ "${mail}.desktop" ];
    browser = [ "${browser}.desktop" ];
    office = [ "${office}.desktop" ];
    pdf = [ "${browser}.desktop" ];
    ebook = [ "calibre.desktop" ];
    magnet = [ "qbittorrent.desktop" ];
  };

  mimeMap = {
    text = [ "text/plain" ];
    image = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/png"
      "image/svg+xml"
      "image/tiff"
      "image/vnd.microsoft.icon"
      "image/webp"
    ];
    audio = [
      "audio/aac"
      "audio/mpeg"
      "audio/ogg"
      "audio/opus"
      "audio/wav"
      "audio/webm"
      "audio/x-matroska"
    ];
    video = [
      "video/mp2t"
      "video/mp4"
      "video/mpeg"
      "video/ogg"
      "video/webm"
      "video/x-flv"
      "video/x-matroska"
      "video/x-msvideo"
    ];
    directory = [ "inode/directory" ];
    mail = [ "x-scheme-handler/mailto" ];
    calendar = [
      "text/calendar"
      "x-scheme-handler/webcal"
    ];
    browser = [
      "text/html"
      "x-scheme-handler/about"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/unknown"
    ];
    office = [
      "application/vnd.oasis.opendocument.text"
      "application/vnd.oasis.opendocument.spreadsheet"
      "application/vnd.oasis.opendocument.presentation"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "application/msword"
      "application/vnd.ms-excel"
      "application/vnd.ms-powerpoint"
      "application/rtf"
    ];
    pdf = [ "application/pdf" ];
    ebook = [ "application/epub+zip" ];
    magnet = [ "x-scheme-handler/magnet" ];
  };

  associations =
    with lists;
    listToAttrs (
      flatten (mapAttrsToList (key: map (type: attrsets.nameValuePair type defaultApps."${key}")) mimeMap)
    );
in

{
  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };

  home.sessionVariables = {
    WINEDLLOVERRIDES = "winemenubuilder.exe=d"; # prevent wine from creating file associations
  };
}