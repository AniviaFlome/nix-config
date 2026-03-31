{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;
    cache.enable = true;
    flavor = "mocha";
    accent = "mauve";

    limine.enable = true;
    sddm.enable = true;
    tty.enable = true;
  };

  environment.systemPackages = with pkgs; [
    catppuccin-cursors.mochaMauve
    catppuccin-qt5ct
  ];
}
