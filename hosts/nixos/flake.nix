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
      lib = config.flake.lib;
    };
    modules = [
      ./configuration.nix
      inputs.nur.modules.nixos.default
    ];
  };

  flake.homeConfigurations = {
    "${config.flake.variables.username}@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
      inherit (self.nixosConfigurations.nixos) pkgs;
      extraSpecialArgs = config.flake.variables // {
        inherit inputs self;
      };
      modules = [ ./home.nix ];
    };
  };
}
