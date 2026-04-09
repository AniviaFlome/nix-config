{
  username,
  inputs,
  ...
}:
{
  imports = [
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./home.nix;
    extraSpecialArgs = {
      inherit inputs;
    };
  };

  system.stateVersion = "24.05";
}
