{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
android-tools
ani-cli
antimicrox
atuin
bat
bleachbit
brave
boxbuddy
btrfs-progs
bubblewrap
calibre
cascadia-code
cpu-x
crow-translate
curl
distrobox
efibootmgr
element-web
easyeffects
eza
fastfetch
flameshot
fluent-reader
fzf
gdu
gimp
git
gparted
grsync
gpu-screen-recorder-gtk
handbrake
home-manager
htop
kdePackages.kdeconnect-kde
kdePackages.partitionmanager
kdiskmark
kitty
krita
lazygit
libimobiledevice
libreoffice-still
livecaptions
localsend
ludusavi
lutris
man
mangayomi
mangohud
motrix
mousam
mpv
neovim
nicotine-plus
nixd
nixfmt-rfc-style
nodejs_22
normcap
ntfs3g
obs-studio
osu-lazer-bin
pacman
pipx
prismlauncher
protontricks
protonup-qt
protonup-ng
python3
python312Packages.pip
qbittorrent
qutebrowser
ranger
rclone
riseup-vpn
rsync
rofi-wayland
ryujinx
rpcs3
sbctl
smartmontools
songrec
spotdl
spotify
starship
strawberry
syncthing
telegram-desktop
textpieces
thunderbird
tldr
tor-browser
umu-launcher
unrar
unzip
upscayl
varia
ventoy-full
vesktop
vlc
vscodium
wget
wine-staging
winetricks
wl-clipboard
xdg-ninja
xdg-utils
xwaylandvideobridge
youtube-music
yt-dlp
ytfzf
zapret
zathura
zoxide
  ];
}
