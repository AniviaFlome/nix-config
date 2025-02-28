{  username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hardware-custom.nix
      ./imports.nix
    ];

  networking.hostName = "nixos";

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "wheel" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
