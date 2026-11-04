{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.dankcalendar.homeModules.dank-calendar ];

  programs.dank-calendar = {
    enable = true;
    package = (inputs.dankcalendar.lib.mkDcal pkgs).overrideAttrs {
      vendorHash = "sha256-JT6mHK52mIJh4lzVWYVpqNY2S2oeinSWBIKaI3TiY34=";
    };
    systemd = {
      enable = true;
    };
    settings = {
      showTrayIcon = false;
      use24HourClock = true;
    };
  };
}
