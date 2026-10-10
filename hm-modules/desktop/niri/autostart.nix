{
  pkgs,
  ...
}:
{
  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [ "kdeconnectd" ];
      }
      {
        command = [
          "nixdatifier"
          "--background"
        ];
      }
      {
        command = [ "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1" ];
      }
    ];
  };
}
