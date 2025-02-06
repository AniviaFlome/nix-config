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
    # Hyprpanel
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprpanel.inputs.nixpkgs.follows = "nixpkgs";
    # Sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    # Nix-mineral
    nix-mineral.url = "github:cynicsketch/nix-mineral";
    nix-mineral.flake = false;
    # Nvf
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }
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
      ];
    };
  };
}

