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
    lanzaboote.url = "github:nix-community/lanzaboote";
    niri.url = "github:sodiboo/niri-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmenu = {
      url = "github:AniviaFlome/tmenu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yt-x = {
      url = "github:Benexl/yt-x";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
      ];
      variables = (import ./misc/variables.nix)._module.args;
      inherit (variables) username;
      eachSystem = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./misc/treefmt.nix);
    in
    {
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hosts/nixos/configuration.nix
            inputs.determinate.nixosModules.default
            inputs.nixos-hardware.nixosModules.asus-fa507nv
            inputs.nur.modules.nixos.default
          ];
        };
        liveiso = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/liveiso/configuration.nix ];
        };
        liveiso-minimal = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/liveiso-minimal/configuration.nix ];
        };
      };

      homeConfigurations = {
        ${username} = inputs.home-manager.lib.homeManagerConfiguration {
          inherit (self.nixosConfigurations.nixos) pkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/nixos/home.nix ];
        };
      };
    };
}
