{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "video=1920x1080"
      "rcutree.enable_rcu_lazy=1"
    ];
  };

  environment.systemPackages = with pkgs; [ sbctl ];
}
