{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    nautilus
  ];

  systemd.user.services.niri-flake-polkit.enable = false;
}
