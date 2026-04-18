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
              PROTOCOL=efi_chainload
              IMAGE_PATH=uuid(12CE-A600):/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];
}
