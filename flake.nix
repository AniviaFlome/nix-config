{
  description = "My Nixos configuration";

  nixConfig = {
    extra-experimental-features = [
      "cgroups"
      "flakes"
      "nix-command"
      "pipe-operator"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-webapps.url = "github:AniviaFlome/nix-webapps";
    nix-mineral.url = "github:cynicsketch/nix-mineral";
    nix-themes.url = "github:aniviaflome/nix-themes";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    llm-agents.url = "github:numtide/llm-agents.nix";
    kopuz.url = "github:temidaradev/kopuz";
    flake-parts.url = "github:hercules-ci/flake-parts";
    millennium.url = "github:SteamClientHomebrew/Millennium/next?dir=packages/nix";
    dms-plugins = {
      url = "github:AvengeMedia/dms-plugins";
      flake = false;
    };
    julius-skills = {
      url = "github:JuliusBrussee/skills";
      flake = false;
    };
    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wizard = {
      url = "github:km-clay/nixos-wizard";
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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-cli = {
      url = "github:nix-community/nixos-cli";
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
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [ ./flake ];
    };
}
