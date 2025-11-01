{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.stable; [
    gimp
    grsync
    normcap
    pokerth
    rpcs3
  ];
}
