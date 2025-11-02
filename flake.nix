{
  description = "My Nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    catppuccin.url = "github:catppuccin/nix";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    niri.url = "github:sodiboo/niri-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    tmenu.url = "github:AniviaFlome/tmenu";
    distrobox.url = "github:AniviaFlome/distrobox-flake";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        {
          treefmt.config = import ./treefmt.nix;
          formatter = config.treefmt.build.wrapper;
          checks = {
            formatting = config.treefmt.build.check self;
          };
        };

      flake =
        let
          inherit (self) outputs;
          system = "x86_64-linux";
          username = "aniviaflome";
        in
        {
          nixosConfigurations = {
            nixos = inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit
                  inputs
                  outputs
                  system
                  username
                  ;
              };
              modules = [
                ./hosts/nixos/configuration.nix
                inputs.determinate.nixosModules.default
                inputs.nixos-hardware.nixosModules.asus-fa507nv
                inputs.nur.modules.nixos.default
              ];
            };
            liveiso = inputs.nixpkgs-stable.lib.nixosSystem {
              specialArgs = {
                inherit
                  inputs
                  outputs
                  ;
              };
              modules = [ ./hosts/liveiso/configuration.nix ];
            };
            liveiso-minimal = inputs.nixpkgs-stable.lib.nixosSystem {
              specialArgs = {
                inherit
                  inputs
                  outputs
                  ;
              };
              modules = [ ./hosts/liveiso-minimal/configuration.nix ];
            };
          };

          homeConfigurations = {
            ${username} = inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = inputs.nixpkgs.legacyPackages.${system};
              extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  system
                  username
                  ;
              };
              modules = [ ./hosts/nixos/home.nix ];
            };
          };
        };
    };
}
