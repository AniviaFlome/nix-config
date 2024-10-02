{ pkgs, lanzaboote, ... }:

{
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["video=1920x1080"];
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
  environment.systemPackages = with pkgs; [ sbctl ];
}
