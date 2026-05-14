{
  pkgs,
  inputs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-combined.nix"
    ../../modules/system/documentation.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  console.keyMap = "trq";

  networking.networkmanager.enable = true;
  environment.systemPackages =
    with pkgs;
    [
      curl
      disko
      git
      micro
      neovim
      parted
      rsync
    ]
    ++ lib.optional (inputs ? nixos-wizard) inputs.nixos-wizard.packages.${pkgs.system}.default;

  boot.kernelParams = [ "video=1920x1080" ];

  console.colors = [
    "1e1e2e"
    "f38ba8"
    "a6e3a1"
    "f9e2af"
    "89b4fa"
    "f5c2e7"
    "94e2d5"
    "bac2de"
    "585b70"
    "f38ba8"
    "a6e3a1"
    "f9e2af"
    "89b4fa"
    "f5c2e7"
    "94e2d5"
    "a6adc8"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.supportedFilesystems.zfs = false;

  isoImage.squashfsCompression = "xz -Xdict-size 100%";
}
