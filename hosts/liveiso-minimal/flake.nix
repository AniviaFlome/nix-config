{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.liveiso-minimal = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs self; };
    modules = [ ./configuration.nix ];
  };
}
