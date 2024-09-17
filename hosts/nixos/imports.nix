{ config, ... }:

{
  imports = [
    ../../modules/packages/flatpak/default.nix
    ../../modules/packages/nix/pkgs.nix
    ../../modules/packages/nix/pkgs-stable.nix
    ../../modules/gaming/gamemode.nix
    ../../modules/gaming/steam.nix
    ../../modules/programs/cups.nix
    ../../modules/programs/hyprland.nix
    ../../modules/programs/kde-plasma.nix
    ../../modules/programs/podman.nix
    ../../modules/programs/xorg.nix
    ../../modules/security/fail2ban.nix
    ../../modules/security/firewall.nix
    ../../modules/system/allow-unfree.nix
    ../../modules/system/bootloader.nix
    ../../modules/system/display-manager.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/pipewire.nix
    ../../modules/system/shell.nix
    ../../modules/system/xdg-portal.nix
    ../../modules/virtualization/virt-manager.nix
    ../../modules/virtualization/waydroid.nix
    ../../modules/system/nh.nix
    ../../modules/theme/cursor.nix
    ../../modules/theme/plymouth.nix
  ];
}
