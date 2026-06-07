{
  flake.modules.nixos.syncthing =
    { username, config, ... }:
    {
      services.syncthing = {
        enable = true;
        user = username;
        dataDir = config.users.users.${username}.home;
        guiPasswordFile = config.sops.secrets."syncthing-password".path;
        settings = {
          gui = {
            user = username;
          };
          devices = {
            "Nothing" = {
              id = "42T4OWN-HMB3OIA-HIPJBAP-3U6CBS2-Q3RO5RH-ODSMH4L-UU2VC7K-N2U6SQD";
            };
          };
          folders = {
            "Music" = {
              path = "${config.users.users.${username}.home}/Music";
              devices = [ "Nothing" ];
              ignore = [ ".thumbnails" ];
            };
            "Syncthing" = {
              path = "${config.users.users.${username}.home}/Syncthing";
              devices = [ "Nothing" ];
              ignore = [ ".thumbnails" ];
            };
          };
        };
      };
    };
}
