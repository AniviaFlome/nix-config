{
  inputs,
  ...
}:
{
  imports = [ inputs.dankcalendar.homeModules.dank-calendar ];

  programs.dank-calendar = {
    enable = true;
    systemd = {
      enable = true;
    };
    settings = {
      showTrayIcon = false;
      use24HourClock = true;
    };
  };
}
