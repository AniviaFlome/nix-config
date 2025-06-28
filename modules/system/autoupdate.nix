{ inputs, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "nixpkgs-stable"
    ];
    dates = "20:00";
    randomizedDelaySec = "45min";
  };
}
