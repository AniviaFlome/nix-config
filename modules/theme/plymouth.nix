{ pkgs, ... }:

{
  boot.plymouth = {
    enable = true;
    themePackages = with pkgs; [
      (catppuccin-plymouth.override { variant = "mocha"; })
    ];
    theme = "catppuccin-mocha";
  };
}
