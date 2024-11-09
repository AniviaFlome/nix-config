# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, outputs, ... }:

{
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      ./hardware-configuration.nix
      ./hardware-custom.nix
      ./imports.nix
    ];

  # Define your hostname.
  networking.hostName = "nixos";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aniviaflome = {
    isNormalUser = true;
    description = "AniviaFlome";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DO NOT TOUCH THIS
  system.stateVersion = "24.05";
}
