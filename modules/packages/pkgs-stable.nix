{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    kdePackages.kdenlive
    losslesscut-bin
    rpcs3
  ];
}
