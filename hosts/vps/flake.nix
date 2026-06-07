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
  flake.nixosConfigurations.vps = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = config.flake.variables // {
      inherit inputs self;
      inherit (config.flake) lib;
    };
    modules = [
      m.nixos.documentation
      m.nixos.locale
      m.nixos.nh
      m.nixos.nix-settings
      m.nixos.shell
      m.nixos.sops
      m.nixos.sudo-rs
      m.nixos.fail2ban-vps
      m.nixos.firewall-vps
      m.nixos.glances
      m.nixos.freshrss
      m.nixos.traefik
      m.nixos.waha
      inputs.disko.nixosModules.disko
      ./disk-config.nix
      ./hardware-configuration.nix
      {
        boot = {
          supportedFilesystems = [ "ext4" ];
          loader.grub = {
            efiSupport = true;
            efiInstallAsRemovable = true;
          };
        };
        services.openssh.enable = true;
        users.users = {
          vps = {
            isNormalUser = true;
            extraGroups = [
              "wheel"
              "docker"
            ];
            initialPassword = "1234";
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXW5gqP/C/NQYWmWLPefoQZkZI59/O1EjptVuzvA7gA aniviaflome@gmail.com"
            ];
          };
          root.initialPassword = "1234";
        };
        system.stateVersion = "24.05";
      }
      (
        { modulesPath, pkgs, ... }:
        {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            (modulesPath + "/profiles/qemu-guest.nix")
          ];
          environment.systemPackages = with pkgs; [
            curl
            micro-full
          ];
        }
      )
    ];
  };
}
