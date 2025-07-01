{
  description = "My Nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    catppuccin.url = "github:catppuccin/nix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
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
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, nur, ... }
  @ inputs: let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
    lib = nixpkgs.lib;
    username = "aniviaflome";
    browser = "zen-browser";
    file = "dolphin";
    menu = "rofi -show drun -theme /home/aniviaflome/.config/rofi/launchers/type-5/style-3.rasi";
    music = "spotify";
    screenshot = builtins.toPath ./scripts/screenshot.nix;
    terminal = "kitty";
    wallpaper = builtins.toPath ./hm-modules/wallpaper/wallpaper.png;
  in {

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          username = "aniviaflome";
          inherit inputs outputs pkgs-stable system;
        };
        modules = [
          ./hosts/nixos/configuration.nix
          nur.modules.nixos.default
          determinate.nixosModules.default
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      liveiso = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs pkgs-stable system username;
        };
        modules = [
          ./hosts/liveiso/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      liveiso-minimal = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs pkgs-stable system username;
        };
        modules = [
          ./hosts/liveiso-minimal/configuration.nix
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
          inherit inputs outputs pkgs-stable system username browser file menu music screenshot terminal wallpaper;
        };
        modules = [
          ./hosts/nixos/home.nix
        ];
      };
    };
  };
}
