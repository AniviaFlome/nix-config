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
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
