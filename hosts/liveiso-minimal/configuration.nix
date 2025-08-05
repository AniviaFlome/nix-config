{ pkgs, lib, modulesPath, username, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
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
    micro
    neovim
    parted
    rsync
  ];

  boot.kernelParams = [
    "video=1920x1080"
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
