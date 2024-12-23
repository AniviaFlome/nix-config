{
  description = "My Nixos configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Nix flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";
    # Nixvim
    nixvim.url = "github:nix-community/nixvim";
    # Ags
    ags.url = "github:Aylur/ags";
    # Lanzaboote
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    # Umu
    umu.url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
    umu.inputs.nixpkgs.follows = "nixpkgs";
    # Spicetify-nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nix-flatpak, catppuccin, nixvim, lanzaboote, ...}
  @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    lib = nixpkgs.lib;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        username = "aniviaflome";
        inherit inputs outputs pkgs-stable;
      };
        modules = [
          ./hosts/nixos/configuration.nix
          nix-flatpak.nixosModules.nix-flatpak
          catppuccin.nixosModules.catppuccin
          lanzaboote.nixosModules.lanzaboote
          inputs.home-manager.nixosModules.home-manager
        ];
    };

    homeConfigurations.nixos = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        username = "aniviaflome";
        inherit inputs outputs;
      };
      modules = [
        ./hosts/nixos/home.nix
        catppuccin.homeManagerModules.catppuccin
        inputs.nixvim.homeManagerModules.nixvim
        inputs.spicetify-nix.homeManagerModules.default
      ];
    };
  };
}

