{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    # keep-sorted start case=no
    kdePackages.kdenlive
    losslesscut-bin
    # keep-sorted end
  ];
}
