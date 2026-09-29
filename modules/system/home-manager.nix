{
  flakeVars,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = flakeVars // {
      inherit inputs;
    };
    users.${username} = {
      imports = [ ../../hosts/nixos/home.nix ];
    };
  };
}
