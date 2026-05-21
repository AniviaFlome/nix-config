{
  pkgs,
  inputs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
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
      grsync
      kitty
      micro
      neovim
      parted
      rsync
      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
        font = "Noto Sans";
        fontSize = "9";
        loginBackground = false;
      })
    ]
    ++ lib.optional (inputs ? nixos-wizard) inputs.nixos-wizard.packages.${pkgs.system}.default;

  services.displayManager = lib.mkForce {
    sddm = {
      enable = true;
      autoNumlock = true;
      theme = "catppuccin-mocha-mauve";
      wayland = {
        enable = false;
        compositor = "kwin";
      };
    };
    defaultSession = "plasmax11";
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

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

  nixpkgs.config = {
    allowUnfree = true;
  };

  isoImage.squashfsCompression = "xz -Xdict-size 100%";
}
