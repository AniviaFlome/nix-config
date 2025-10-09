{ inputs, pkgs, system, username, ... }:

{
  environment.systemPackages = [
    inputs.winboat.packages.${system}.winboat
    pkgs.freerdp
  ];
}
