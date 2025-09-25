{ pkgs, lib, modulesPath, username, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel.nix"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.xserver.xkb.layout = "tr";

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

  console.colors = [ "1e1e2e" "f38ba8" "a6e3a1" "f9e2af" "89b4fa" "f5c2e7" "94e2d5" "bac2de" "585b70" "f38ba8" "a6e3a1" "f9e2af" "89b4fa" "f5c2e7" "94e2d5" "a6adc8" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  isoImage.squashfsCompression = "xz -Xdict-size 100%";
}
