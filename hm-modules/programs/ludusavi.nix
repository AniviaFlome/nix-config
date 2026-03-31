{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.ludusavi = {
    enable = true;
    frequency = "daily";
    settings = {
      theme = "dark";
      backup = {
        path = "${config.home.homeDirectory}/Random/Backup/Ludusavi";
      };
      apps = {
        rclone = {
          executable = lib.getExe pkgs.rclone;
          arguments = "--fast-list";
        };
      };
      cloud = {
        path = "ludusavi-backup";
        synchronize = true;
        remote = {
          GoogleDrive = {
            id = "ludusavi-1764951022";
          };
        };
      };
      roots = [
        {
          store = "steam";
          path = "${config.home.homeDirectory}/.local/share/Steam";
        }
        {
          store = "heroic";
          path = "${config.home.homeDirectory}/.config/heroic";
        }
        {
          store = "lutris";
          path = "${config.home.homeDirectory}/.local/share/lutris";
          database = "${config.home.homeDirectory}/.local/share/lutris/pga.db";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    rclone
  ];
}
