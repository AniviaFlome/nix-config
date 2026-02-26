{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    calibre
    joplin-desktop
    kdePackages.kdenlive
    krita
    libresprite
    losslesscut-bin
    normcap
    rpcs3
  ];
}
