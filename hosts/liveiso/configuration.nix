{
  inputs,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
    inputs.home-manager.nixosModules.home-manager
    ../../modules/theme/catppuccin.nix
    ../liveiso-minimal/configuration.nix
  ];

  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  users.users.nixos.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    # keep-sorted start case=no
    gparted
    kitty
    # keep-sorted end
  ];

  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    defaultSession = "plasma";
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users.nixos = {
      imports = [ ./home.nix ];
    };
  };

  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          default_area = "navbar";
          private_browsing = true;
        };
      };
    };
  };
}
