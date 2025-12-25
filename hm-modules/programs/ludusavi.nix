{
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
        path = "~/Random/Backup/Ludusavi";
      };
      apps = {
        rclone = {
          executable = "${pkgs.rclone}/bin/rclone";
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
          path = "~/.local/share/Steam";
        }
        {
          store = "heroic";
          path = "~/.config/heroic";
        }
        {
          store = "lutris";
          path = "~/.local/share/lutris";
          database = "~/.local/share/lutris/pga.db";
        }
      ];
    };
  };

  home.packages = with pkgs; [ rclone ];
}
