{ pkgs, inputs, ... }:

{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = ["video=1920x1080"];
  };

  environment.systemPackages = with pkgs; [ sbctl ];
}
