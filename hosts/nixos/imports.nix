{
  imports = [
    # Flake-Misc
    ../../misc/variables.nix
    # Gaming
    ../../modules/gaming/gamescope.nix
    ../../modules/gaming/gamemode.nix
    ../../modules/gaming/prism-launcher.nix
    ../../modules/gaming/retroarch.nix
    ../../modules/gaming/steam.nix
    # Packages
    ../../modules/packages/flatpak.nix
    ../../modules/packages/pkgs-stable.nix
    ../../modules/packages/pkgs.nix
    # Programs
    ../../modules/programs/adb.nix
    ../../modules/programs/cups.nix
    ../../modules/programs/cups.nix
    ../../modules/programs/kde-connect.nix
    ../../modules/programs/plasma.nix
    ../../modules/programs/niri.nix
    ../../modules/programs/oom.nix
    ../../modules/programs/docker.nix
    ../../modules/programs/podman.nix
    ../../modules/programs/snapper.nix
    ../../modules/programs/virtualization.nix
    ../../modules/programs/waydroid.nix
    # Security
    ../../modules/security/fail2ban.nix
    ../../modules/security/firewall.nix
    # Server
    ../../modules/server/wordpress.nix
    # System
    ../../modules/system/appimage.nix
    ../../modules/system/autoupdate.nix
    ../../modules/system/battery.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/bootloader.nix
    ../../modules/system/cachy.nix
    ../../modules/system/display-manager.nix
    ../../modules/system/fonts.nix
    ../../modules/system/locale.nix
    ../../modules/system/network.nix
    ../../modules/system/nh.nix
    ../../modules/system/nix.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/nix-mineral.nix
    ../../modules/system/pipewire.nix
    ../../modules/system/shell.nix
    ../../modules/system/secrets.nix
    ../../modules/system/ssh.nix
    ../../modules/system/sops-nix.nix
    ../../modules/system/sudo-rs.nix
    ../../modules/system/uutils.nix
    ../../modules/system/xdg-portal.nix
    ../../modules/system/xorg.nix
    # Theme
    ../../modules/theme/catppuccin.nix
  ];
}
