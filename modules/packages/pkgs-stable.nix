{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    calibre
    grim
    joplin-desktop
    kdePackages.kdenlive
    krita
    losslesscut-bin
    normcap
    rpcs3
  ];
}
