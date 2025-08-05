{ pkgs, lib, modulesPath, username, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
    ../../modules/theme/catppuccin.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    curl
    disko
    git
    grsync
    kitty
    micro
    neovim
    parted
    rsync
  ];

  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland = {
        enable = false;
        compositor = "kwin";
      };
    };
    defaultSession = "plasmax11";
    autoLogin = {
        enable = true;
        user = "${username}";
    };
  };

  boot.kernelParams = [
    "video=1920x1080"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
