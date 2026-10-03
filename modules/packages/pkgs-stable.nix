{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs.stable; [
    # keep-sorted start case=no
    hydralauncher
    kdePackages.kdenlive
    mindustry-wayland
    openutau
    zotero
    # keep-sorted end
  ];
}
