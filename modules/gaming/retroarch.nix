{ pkgs, ... }:

let
  retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
melonds
ppsspp
  ]));
in

{
  environment.systemPackages = [
    retroarchWithCores
  ];
}
