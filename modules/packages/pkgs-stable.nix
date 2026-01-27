{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    joplin-desktop
    kdePackages.kdenlive
    normcap
    pokerth
    rpcs3
  ];
}
