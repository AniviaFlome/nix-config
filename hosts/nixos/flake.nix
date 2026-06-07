{
  self,
  config,
  inputs,
  ...
}:
let
  m = config.flake.modules;
in
{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = config.flake.variables // {
      inherit inputs self;
      inherit (config.flake) lib;
      flakeVars = config.flake.variables;
    };
    modules = [
      m.nixos.home-manager
      m.nixos.appimage
      m.nixos.battery
      m.nixos.bluetooth
      m.nixos.bootloader
      m.nixos.cachy
      m.nixos.catppuccin
      m.nixos.display-manager
      m.nixos.dns
      m.nixos.documentation
      m.nixos.docker
      m.nixos.fail2ban
      m.nixos.firewall
      m.nixos.flatpak
      m.nixos.fonts
      m.nixos.fwupd
      m.nixos.gamemode
      m.nixos.gamescope
      m.nixos.gpu-screen-recorder
      m.nixos.kdeconnect
      m.nixos.kernel
      m.nixos.locale
      m.nixos.network
      m.nixos.nh
      m.nixos.niri
      m.nixos.nix-ld
      m.nixos.nix-settings
      m.nixos.obs-studio
      m.nixos.oom
      m.nixos.pipewire
      m.nixos.plasma
      m.nixos.podman
      m.nixos.pkgs
      m.nixos.pkgs-stable
      m.nixos.shell
      m.nixos.snapper
      m.nixos.sops
      m.nixos.steam
      m.nixos.syncthing
      m.nixos.sudo-rs
      m.nixos.uutils
      m.nixos.virtualization
      m.nixos.waydroid
      m.nixos.xdg
      m.nixos.xorg
      m.nixos.zapret
      ./hardware-configuration.nix
      ./hardware-custom.nix
      (
        { username, ... }:
        {
          networking.hostName = "nixos";
          users.users.${username} = {
            isNormalUser = true;
            description = username;
            extraGroups = [ "wheel" ];
          };
          system.stateVersion = "24.05";
        }
      )
    ];
  };
}
