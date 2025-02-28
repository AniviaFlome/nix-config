{
  description = "My Nixos configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Nix flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";
    # Lanzaboote
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    # Spicetify-nix
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    # Plasma-manager
    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    # Sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    # Nix-mineral
    nix-mineral.url = "github:cynicsketch/nix-mineral";
    nix-mineral.flake = false;
    # Nvf
    nvf.url = "github:notashelf/nvf";
    # Zen-browser
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }
  @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    lib = nixpkgs.lib;
    username = "aniviaflome";
  in {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs pkgs-stable username system;
        };
        modules = [
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      liveiso = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs pkgs-stable username system;
        };
        modules = [
          ./hosts/nixos/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    homeConfigurations = {
      ${username} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs outputs pkgs-stable username system;
        };
        modules = [
          ./hosts/nixos/home.nix
        ];
      };
    };
  };
}
