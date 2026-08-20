{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    # keep-sorted start case=no
    kdePackages.kdenlive
    mindustry-wayland
    # keep-sorted end
  ];
}
