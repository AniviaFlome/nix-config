{
  flake.modules.nixos.bootloader =
    { pkgs, ... }:
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
                  protocol: efi
                  path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
            '';
          };
        };
      };
      environment.systemPackages = with pkgs; [ sbctl ];
    };
}
