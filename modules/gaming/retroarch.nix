{ pkgs, ... }:

let
  retroarchWithCores = pkgs.retroarch.withCores (cores: with cores; [
    melonds
    ppsspp
    np2kai
  ]);
in

{
  environment.systemPackages = [
    retroarchWithCores
  ];
}
