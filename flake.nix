{
  description = "My Nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    catppuccin.url = "github:catppuccin/nix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    niri.url = "github:sodiboo/niri-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:kaylorben/nixcord";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    cachy-tweaks = {
      url = "github:AniviaFlome/cachy-tweaks-flake";
      inputs.nixpkgs.follows = "nixpkgs";
     };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      flake = false;
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lsfg-vk = {
      url = "github:pabloaul/lsfg-vk-flake/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nur, nixos-hardware, determinate, ... }
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
          inherit inputs outputs pkgs-stable system username;
        };
        modules = [
          ./hosts/nixos/configuration.nix
          nur.modules.nixos.default
          nixos-hardware.nixosModules.asus-fa507nv
          determinate.nixosModules.default
        ];
      };
      liveiso = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs pkgs pkgs-stable system username;
        };
        modules = [
          ./hosts/liveiso/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
      liveiso-minimal = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs pkgs pkgs-stable system username;
        };
        modules = [
          ./hosts/liveiso-minimal/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      ${username} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          inherit inputs outputs pkgs-stable system username;
        };
        modules = [
          ./hosts/nixos/home.nix
        ];
      };
    };
  };
}
