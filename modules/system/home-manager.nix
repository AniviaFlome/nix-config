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
    extraSpecialArgs = flakeVars // {
      inherit inputs;
    };
    users.${username} = {
      imports = [ ../../hosts/nixos/home.nix ];
    };
  };
}
