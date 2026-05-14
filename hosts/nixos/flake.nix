{
  config,
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = config.flake.variables // {
      inherit inputs self;
      inherit (config.flake) lib;
      flakeVars = config.flake.variables;
    };
    modules = [ ./configuration.nix ];
  };
}
