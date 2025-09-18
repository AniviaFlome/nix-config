{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (lib.hiPrio pkgs.uutils-coreutils-noprefix)
  ];
}
