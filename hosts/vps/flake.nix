{
  config,
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.vps = inputs.nixpkgs-stable.lib.nixosSystem {
    specialArgs = config.flake.variables // {
      inherit inputs self;
      lib = config.flake.lib;
    };
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      ./configuration.nix
    ];
  };
}
