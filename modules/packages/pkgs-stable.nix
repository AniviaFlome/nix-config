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
    losslesscut-bin
    normcap
    rpcs3
  ];
}
