{ config, inputs, outputs, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hardware-custom.nix
      ./imports.nix
    ];

  networking.hostName = "nixos";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "AniviaFlome";
    extraGroups = [ "wheel" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # DO NOT TOUCH THIS
  system.stateVersion = "24.05";
}
