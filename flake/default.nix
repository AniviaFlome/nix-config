{ ... }:
{
  imports = [
    ./variables.nix
    ./lib.nix
    ./formatter.nix
    ./shell.nix

    ../hosts/nixos/flake.nix
    ../hosts/vps/flake.nix
    ../hosts/liveiso/flake.nix
    ../hosts/liveiso-minimal/flake.nix

    ../modules/system/appimage.nix
    ../modules/system/battery.nix
    ../modules/system/bluetooth.nix
    ../modules/system/bootloader.nix
    ../modules/system/cachy.nix
    ../modules/system/display-manager.nix
    ../modules/system/dns.nix
    ../modules/system/documentation.nix
    ../modules/system/fonts.nix
    ../modules/system/home-manager.nix
    ../modules/system/kernel.nix
    ../modules/system/locale.nix
    ../modules/system/network.nix
    ../modules/system/nh.nix
    ../modules/system/nix.nix
    ../modules/system/nix-ld.nix
    ../modules/system/pipewire.nix
    ../modules/system/shell.nix
    ../modules/system/sops.nix
    ../modules/system/sudo-rs.nix
    ../modules/system/uutils.nix
    ../modules/system/xdg.nix
    ../modules/system/xorg.nix

    ../modules/gaming/gamescope.nix
    ../modules/gaming/gamemode.nix
    ../modules/gaming/steam.nix

    ../modules/packages/flatpak.nix
    ../modules/packages/pkgs-stable.nix
    ../modules/packages/pkgs.nix

    ../modules/programs/docker.nix
    ../modules/programs/fwupd.nix
    ../modules/programs/gpu-screen-recorder.nix
    ../modules/programs/kdeconnect.nix
    ../modules/programs/plasma.nix
    ../modules/programs/niri
    ../modules/programs/obs-studio.nix
    ../modules/programs/oom.nix
    ../modules/programs/podman.nix
    ../modules/programs/snapper.nix
    ../modules/programs/virtualization.nix
    ../modules/programs/waydroid.nix
    ../modules/programs/zapret.nix

    ../modules/security/fail2ban.nix
    ../modules/security/firewall.nix

    ../modules/server/syncthing.nix

    ../modules/options/waha.nix

    ../modules/misc/manual.nix
    ../modules/misc/mime.nix
    ../modules/misc/nix-hm.nix
    ../modules/misc/variables-hm.nix
    ../modules/misc/xdg-hm.nix

    ../modules/programs/antigravity.nix
    ../modules/programs/atuin.nix
    ../modules/programs/bash.nix
    ../modules/programs/bat.nix
    ../modules/programs/claude-code.nix
    ../modules/programs/difftastic.nix
    ../modules/programs/direnv.nix
    ../modules/programs/easyeffects
    ../modules/programs/fastfetch
    ../modules/programs/fish.nix
    ../modules/programs/git.nix
    ../modules/programs/kate.nix
    ../modules/programs/kitty.nix
    ../modules/programs/konsole.nix
    ../modules/programs/ludusavi.nix
    ../modules/programs/mcp.nix
    ../modules/programs/mergiraf.nix
    ../modules/programs/micro.nix
    ../modules/programs/mpv.nix
    ../modules/programs/nix-index.nix
    ../modules/programs/nix-webapps.nix
    ../modules/programs/nixcord.nix
    ../modules/programs/nushell.nix
    ../modules/programs/nvf
    ../modules/programs/nyaa.nix
    ../modules/programs/opencode.nix
    ../modules/programs/qutebrowser.nix
    ../modules/programs/ripgrep.nix
    ../modules/programs/shell-aliases.nix
    ../modules/programs/sldl.nix
    ../modules/programs/spicetify.nix
    ../modules/programs/spotify-player.nix
    ../modules/programs/starship.nix
    ../modules/programs/thunderbird.nix
    ../modules/programs/tmenu.nix
    ../modules/programs/zed.nix
    ../modules/programs/zen-browser
    ../modules/programs/zoxide.nix

    ../modules/misc/scripts
    ../modules/misc/scripts/secrets

    ../modules/theme
  ];
}
