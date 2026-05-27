{
  username,
  ...
}:
{
  system.autoUpgrade = {
    enable = true;
    flake = "/home/${username}/nix-config";
    dates = "daily";
    randomizedDelaySec = "45min";
    runGarbageCollection = true;
  };
}
