{ pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  nixos = {
    home-users = {
      "${username}" = {
        userConfig = ./home.nix;
        userSettings = {
          extraGroups = [ "networkmanager" "wheel" ];
        };
      };
    };
  };

  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    disko
    git
    neovim
    parted
    rsync
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
