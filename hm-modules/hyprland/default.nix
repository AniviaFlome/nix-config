{ pkgs, ...}:

{
  xdg.configFile = {
    "ags".source = ./ags;
    "anyrun".source = ./anyrun;
    "fuzzel".source = ./fuzzel;
    "hypr".source = ./hypr;
    "wlogout".source = ./wlogout;
  };
  home.packages = with pkgs; [
axel
libdbusmenu-gtk3
swww
gtk-layer-shell
gtk3
gtksourceview3
yad
ydotool
xdg-user-dirs-gtk
polkit_gnome
gnome-keyring
gnome-control-center
blueberry
gammastep
gnome-bluetooth_1_0
brightnessctl
hypridle
hyprlock
wlogout
wl-clipboard
hyprpicker
anyrun
adw-gtk3
wf-recorder
grim
tesseract
slurp
  ];
}
