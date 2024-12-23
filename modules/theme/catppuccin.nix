{ catppuccin, pkgs, ... }:

{
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    sddm.enable = true;
    tty.enable = true;
  };

  environment.systemPackages = with pkgs; [ catppuccin-cursors.mochaMauve ];
}
