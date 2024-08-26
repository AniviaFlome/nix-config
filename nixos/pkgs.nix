{ config, pkgs, ... }:

{

# List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ani-cli
  antimicrox
  bat
  bitwarden-desktop
  bleachbit
  btrfs-progs
  bubblewrap
  cascadia-code
  cava
  cmatrix
  crow-translate
  curl
  distrobox
  docker
  efibootmgr
  eza
  fastfetch
  fira-code
  flameshot
  fzf
  gdu
  gimp
  git
  gparted
  grsync
  handbrake
  heroic
  home-manager
  htop
  inxi
  jetbrains-mono
  kdePackages.kdeconnect-kde
  kitty
  krita
  kdePackages.ksystemlog
  lazygit
  libreoffice-still
  librewolf
  lutris
  man
  mangohud
  mpv
  neovim
  nwg-look
  obs-studio
  podman
  protontricks
  qbittorrent
  kdePackages.qt6ct
  ranger
  rclone
  riseup-vpn
  rsync
  smartmontools
  songrec
  starship
  strawberry
  telegram-desktop
  tldr
  unrar
  unzip
  ventoy-full
  vscodium
  wget
  wine-staging
  winetricks
  xdg-desktop-portal-gtk
  xdg-utils
  xwaylandvideobridge
  youtube-music
  yt-dlp
  zoxide
  ];

}
