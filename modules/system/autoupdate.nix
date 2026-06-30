{
  config,
  ...
}:
{
  system.autoUpgrade = {
    enable = true;
    flake = "${config.home.homeDirectory}/nix-config";
    dates = "daily";
    randomizedDelaySec = "45min";
    runGarbageCollection = true;
  };
}
