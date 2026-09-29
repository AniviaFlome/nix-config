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
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    multiverse.url = "github:fzakaria/nixpkgs-multiverse";
    sops-nix.url = "github:Mic92/sops-nix";
    nvf.url = "github:notashelf/nvf";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    catppuccin.url = "github:catppuccin/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixcord.url = "github:kaylorben/nixcord";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nix-webapps.url = "github:AniviaFlome/nix-webapps";
    nix-mineral.url = "github:cynicsketch/nix-mineral";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    dankcalendar.url = "github:AvengeMedia/dankcalendar";
    flake-parts.url = "github:hercules-ci/flake-parts";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    kopuz.url = "github:temidaradev/kopuz";
    nirikit.url = "github:AniviaFlome/nirikit";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixgrep.url = "github:AniviaFlome/nixgrep";
    spotifast.url = "github:crmne/spotifast";
    anthropics-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };
    caveman = {
      url = "github:JuliusBrussee/caveman";
      flake = false;
    };
    agent-workspace = {
      url = "github:agent-sh/agent-workspace-linux";
      flake = false;
    };
    computer-use = {
      url = "github:agent-sh/computer-use-linux";
      flake = false;
    };
    context7 = {
      url = "github:upstash/context7";
      flake = false;
    };
    waydroid-nvidia-nix = {
      url = "github:yigexuanmu/waydroid-nvidia-nix/180697edb1ea2c53fed49d6a07d20a39af563083";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bedrock-on-linux = {
      url = "github:Wyze3306/BedrockOnLinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-fork.url = "github:urayde/niri";
    inir = {
      url = "github:snowarch/iNiR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
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
