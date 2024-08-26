# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, outputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # Import home-manager's NixOS module
      inputs.home-manager.nixosModules.home-manager
      ./hardware-configuration.nix
      ./pkgs.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
    

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
 
  # Home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      aniviaflome = import ../home-manager/home.nix;
    };
  };

  # Enable fish 
  programs.fish.enable = true;
  
  # Install Steam 
  programs.steam = {
  enable = true;
  gamescopeSession.enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};

  # Install gamemode
  programs.gamemode.enable = true;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Nix-flatpak
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.remotes = [{
  name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
  }];

  services.flatpak.packages = [
    { appId = "com.adamcake.Bolt"; origin = "flathub";  }
    "com.github.tchx84.Flatseal"
    "com.heroicgameslauncher.hgl"
    "com.pokemmo.PokeMMO"
    "com.stremio.Stremio"
    "com.usebottles.bottles"
    "io.github.dvlv.boxbuddyrs"
    "io.github.giantpinkrobots.flatsweep"
    "io.github.thetumultuousunicornofdarkness.cpu-x"
    "net.davidotek.pupgui2"
    "org.libretro.RetroArch"
    "org.prismlauncher.PrismLauncher"
    "org.ryujinx.Ryujinx"
    "dev.vencord.Vesktop"
    "fr.romainvigier.MetadataCleaner"
    "io.github.giantpinkrobots.varia"
    "com.github.dynobo.normcap"
    "net.sapples.LiveCaptions"
    "org.nicotine_plus.Nicotine"
    "io.github.hmlendea.geforcenow-electron"
    ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Istanbul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "tr_TR.UTF-8";
    LC_IDENTIFICATION = "tr_TR.UTF-8";
    LC_MEASUREMENT = "tr_TR.UTF-8";
    LC_MONETARY = "tr_TR.UTF-8";
    LC_NAME = "tr_TR.UTF-8";
    LC_NUMERIC = "tr_TR.UTF-8";
    LC_PAPER = "tr_TR.UTF-8";
    LC_TELEPHONE = "tr_TR.UTF-8";
    LC_TIME = "tr_TR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    sddm.enable = true;
    autoLogin.enable = true;
    autoLogin.user = "aniviaflome";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "tr";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "trq";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aniviaflome = {
    isNormalUser = true;
    description = "AniviaFlome";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
       
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
