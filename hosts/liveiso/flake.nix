{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.liveiso = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [ ./configuration.nix ];
  };
}
