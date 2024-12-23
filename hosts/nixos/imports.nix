{ config, ... }:

{
  imports = [
# Gaming
../../modules/gaming/gamemode.nix
../../modules/gaming/retroarch.nix
../../modules/gaming/steam.nix
../../modules/gaming/sunshine.nix
../../modules/gaming/umu-launcher.nix
# Packages
../../modules/packages/flatpak.nix
../../modules/packages/fonts.nix
../../modules/packages/pkgs-stable.nix
../../modules/packages/pkgs.nix
# Programs
../../modules/programs/cups.nix
../../modules/programs/docker.nix
../../modules/programs/hyprland.nix
../../modules/programs/kde-plasma.nix
../../modules/programs/podman.nix
../../modules/programs/xorg.nix
../../modules/programs/zapret.nix
# Security
../../modules/security/apparmor.nix
../../modules/security/fail2ban.nix
../../modules/security/firewall.nix
# System
../../modules/system/allow-unfree.nix
../../modules/system/appimage.nix
../../modules/system/bootloader.nix
../../modules/system/display-manager.nix
../../modules/system/libinput.nix
../../modules/system/locale.nix
../../modules/system/networking.nix
../../modules/system/nh.nix
../../modules/system/nix-ld.nix
../../modules/system/pipewire.nix
../../modules/system/shell.nix
../../modules/system/xdg-portal.nix
# Theme
../../modules/theme/catppuccin.nix
# Virtualization
../../modules/virtualization/virt-manager.nix
../../modules/virtualization/waydroid.nix
  ];
}
