{
  pkgs,
  ...
}:
{
  programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
      {
        command = [
          "steam"
          "-silent"
        ];
      }
      {
        command = [
          "vesktop"
          "--start-minimized"
        ];
      }
      {
        command = [
          "kdeconnectd"
        ];
      }
      {
        command = [
          "XDG_MENU_PREFIX=plasma-"
          "kbuildsycoca6"
        ];
      }
      {
        command = [
          "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
        ];
      }
    ];
  };
}
