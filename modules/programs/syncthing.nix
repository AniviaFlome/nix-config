{ config, username, ... }:

let
  key = config.sops.secrets.syncthing.path;
in

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui = {
      user = "${username}";
      password = "$(cat ${key})";
    };
  };
}
