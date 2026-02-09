{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    joplin-desktop
    kdePackages.kdenlive
    libresprite
    losslesscut-bin
    normcap
    rpcs3
  ];
}
