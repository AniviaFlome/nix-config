{ pkgs, ... }:

{
  home.packages = with pkgs; [ waybar ];

  xdg.configFile = {
    "waybar/config".source = ./config.jsonc;
    "waybar/style.css".source = ./style.css;
  };
}
