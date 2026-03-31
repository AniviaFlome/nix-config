{
  description = "My Nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    catppuccin.url = "github:catppuccin/nix";
    lanzaboote.url = "github:nix-community/lanzaboote";
    niri.url = "github:sodiboo/niri-flake";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nix-webapps.url = "github:AniviaFlome/nix-webapps";
    nix-bwrapper.url = "github:Naxdy/nix-bwrapper";
    nix-mineral.url = "github:cynicsketch/nix-mineral/";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    direnv-instant.url = "github:Mic92/direnv-instant";
    niri-session-manager.url = "github:MTeaHead/niri-session-manager";
    distrobox-flake.url = "github:AniviaFlome/distrobox-flake";
    nix-osu.url = "github:yunfachi/nix-osu";
    nix-themes.url = "github:aniviaflome/nix-themes";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    llm-agents.url = "github:numtide/llm-agents.nix";
    dms-plugins = {
      url = "github:AvengeMedia/dms-plugins";
      flake = false;
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-repository = {
      url = "github:AniviaFlome/nix-repository";
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
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    nixpkgs-millennium.url = "github:NixOS/nixpkgs/pull/487045/head";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvirt,
      nixpkgs-millennium,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [
        "x86_64-linux"
      ];
      variables = (import ./misc/variables.nix)._module.args;
      inherit (variables) username;
      lib = nixpkgs.lib.extend (_final: prev: import ./lib { lib = prev; });
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      treefmtEval = forAllSystems (
        system: inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./misc/treefmt.nix
      );
    in
    {
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });

      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              nixvirt
              lib
              ;
          };
          modules = [
            ./hosts/nixos/configuration.nix
            inputs.determinate.nixosModules.default
            inputs.nur.modules.nixos.default
          ];
        };
        vps = inputs.nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              username
              lib
              ;
          };
          system = "x86_64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            ./hosts/vps/configuration.nix
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
        "${username}@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
          inherit (self.nixosConfigurations.nixos) pkgs;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/nixos/home.nix ];
        };
      };
    };
}
