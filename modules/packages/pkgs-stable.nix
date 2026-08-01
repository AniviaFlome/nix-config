{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    # keep-sorted start case=no
    kdePackages.kdenlive
    losslesscut-bin
    mindustry-wayland
    # keep-sorted end
  ];
}
