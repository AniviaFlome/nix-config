{ pkgs, lib, modulesPath, username, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
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
    "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
