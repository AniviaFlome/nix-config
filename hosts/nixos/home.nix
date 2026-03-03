{
  username,
  ...
}:
{
  imports = [ ./hm-imports.nix ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.05";
}
