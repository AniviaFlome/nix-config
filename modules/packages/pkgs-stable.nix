{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    joplin-desktop
    kdePackages.kdenlive
    losslesscut-bin
    normcap
    rpcs3
  ];
}
