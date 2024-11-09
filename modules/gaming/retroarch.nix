{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  (retroarch.override {
    cores = with libretro; [
melonds
ppsspp
    ];
  })
  ];
}
