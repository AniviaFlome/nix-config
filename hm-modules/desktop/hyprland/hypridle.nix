{
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./hyprlock.nix ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        ignore_dbus_inhibit = false;
        lock_cmd = "pidof hyprlock || hyprlock";
        unlock_cmd = "pkill --signal SIGUSR1 hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "";
      };
      listener = [
        {
          timeout = 180; # Seconds
          on-timeout = "brightnessctl -s set 30";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300; # Seconds
          on-timeout = "monitor-off";
        }
        {
          timeout = 300; # Seconds
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    brightnessctl
    hypridle
  ];

  systemd.user.services.hypridle = lib.mkForce { };
}
