{
  pkgs,
  ...
}:
{
  virtualisation.waydroid.enable = true;

  environment.systemPackages = with pkgs; [
    waydroid-helper
  ];

  environment.shellAliases = {
    waydroid-stop = "sudo waydroid container stop && waydroid session stop";
  };
}
