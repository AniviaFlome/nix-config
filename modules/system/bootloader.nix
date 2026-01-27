{
  pkgs,
  ...
}:
{
  boot = {
    loader = {
      timeout = 5;
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        secureBoot.enable = true;
        maxGenerations = 50;
        extraEntries = ''
          /Windows
              protocol: efi_chainload
              image_path: uuid(D4E5-C3DE):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "video=1920x1080"
      "rcutree.enable_rcu_lazy=1"
    ];
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
