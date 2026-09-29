{
  pkgs,
  wallpaper,
  ...
}:
{
  xdg.configFile."weston.ini" = {
    text = ''
      [keyboard]
      numlock-on=true
      keymap_layout=trq

      [core]
      xwayland=true

      [shell]
      panel-position=top
      panel-color=0x001e1e2e
      clock-format=minutes-24h

      background-image=${wallpaper}
      background-type=scale-crop

      startup-animation=none

      cursor-size=24

      [launcher]
      path=${pkgs.tofi}/bin/tofi-drun
      displayname=Launcher

      [launcher]
      path=${pkgs.kdePackages.dolphin}/bin/dolphin
      displayname=File Manager

      [launcher]
      path=${pkgs.kitty}/bin/kitty
      displayname=Terminal
    '';
  };

  home.packages = with pkgs; [
    weston
  ];
}
