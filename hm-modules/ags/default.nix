{ inputs, pkgs, ...}:

{
  home.packages = with pkgs; [
    bun
    dart-sass
    fd
    brightnessctl
    swww
    matugen
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  programs.ags = {
    enable = true;
    configDir = ./ags;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
