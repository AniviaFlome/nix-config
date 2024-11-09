{ config, ... }:

{
  imports = [
    # Gaming
    ../../modules/gaming/gamemode.nix
    ../../modules/gaming/steam.nix
    ../../modules/gaming/sunshine.nix
    ../../modules/gaming/umu-launcher.nix
    # Packages
    ../../modules/packages/flatpak/default.nix
    ../../modules/packages/nix/pkgs-stable.nix
    ../../modules/packages/nix/pkgs.nix
    # Programs
    ../../modules/programs/cups.nix
    ../../modules/programs/docker.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/kde-plasma.nix
    ../../modules/programs/podman.nix
    ../../modules/programs/xorg.nix
    # Security
    ../../modules/security/apparmor.nix
    ../../modules/security/fail2ban.nix
    ../../modules/security/firewall.nix
    # System
    ../../modules/system/allow-unfree.nix
    ../../modules/system/bootloader.nix
    ../../modules/system/display-manager.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nh.nix
    ../../modules/system/pipewire.nix
    ../../modules/system/shell.nix
    ../../modules/system/xdg-portal.nix
    # Theme
    ../../modules/theme/catppuccin.nix
    ../../modules/theme/console.nix
    ../../modules/theme/cursor.nix
    # Virtualization
    ../../modules/virtualization/virt-manager.nix
    ../../modules/virtualization/waydroid.nix
  ];
}
