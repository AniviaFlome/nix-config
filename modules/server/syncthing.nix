{
  config,
  pkgs,
  username,
  ...
}:
{
  services.syncthing = {
    enable = true;
    user = "${username}";
    group = "users";
    dataDir = "/home/${username}/Syncthing";
    settings = {
      gui = {
        user = "${username}";
        passwordFile = config.sops.secrets."syncthing-password".path;
      };
    };
  };

  environment.systemPackages = with pkgs; [ syncthing ];
}
