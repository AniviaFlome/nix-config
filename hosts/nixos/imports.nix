{
  imports = [
    # Flake-Misc
    ../../misc/variables.nix
    # Gaming
    ../../modules/gaming/gamescope.nix
    ../../modules/gaming/gamemode.nix
    ../../modules/gaming/steam.nix
    # Packages
    # ../../modules/packages/bubblewrap.nix
    ../../modules/packages/flatpak.nix
    ../../modules/packages/pkgs-stable.nix
    ../../modules/packages/pkgs.nix
    # Programs
    ../../modules/programs/docker.nix
    ../../modules/programs/kde-connect.nix
    ../../modules/programs/plasma.nix
    ../../modules/programs/niri.nix
    ../../modules/programs/oom.nix
    ../../modules/programs/podman.nix
    ../../modules/programs/printing.nix
    ../../modules/programs/snapper.nix
    ../../modules/programs/virtualization.nix
    ../../modules/programs/waydroid.nix
    ../../modules/programs/zapret.nix
    # Security
    ../../modules/security/fail2ban.nix
    ../../modules/security/firewall.nix
    # System
    ../../modules/system/appimage.nix
    ../../modules/system/autoupdate.nix
    ../../modules/system/battery.nix
    ../../modules/system/bluetooth.nix
    ../../modules/system/bootloader.nix
    ../../modules/system/cachy.nix
    ../../modules/system/display-manager.nix
    ../../modules/system/dns.nix
    ../../modules/system/fonts.nix
    ../../modules/system/kernel.nix
    ../../modules/system/locale.nix
    ../../modules/system/network.nix
    ../../modules/system/nh.nix
    ../../modules/system/nix.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/pipewire.nix
    ../../modules/system/shell.nix
    ../../modules/system/secrets.nix
    ../../modules/system/sops-nix.nix
    ../../modules/system/sudo-rs.nix
    ../../modules/system/uutils.nix
    ../../modules/system/xdg.nix
    ../../modules/system/xorg.nix
    # Theme
    ../../modules/theme/catppuccin.nix
  ];
}
