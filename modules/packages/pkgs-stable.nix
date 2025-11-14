{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    joplin-desktop
    normcap
    pokerth
    rpcs3
  ];
}
