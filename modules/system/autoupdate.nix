{
  self,
  ...
}:
{
  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    dates = "daily";
    randomizedDelaySec = "45min";
    runGarbageCollection = true;
  };
}
