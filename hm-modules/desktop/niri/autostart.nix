{
  discord,
  pkgs,
  ...
}:
let
  runAfterTray = cmd: [
    "bash"
    "-c"
    "timeout 10 gdbus wait --session org.kde.StatusNotifierWatcher && ${cmd}"
  ];
in
{
  programs.niri.settings = {
    spawn-at-startup = [
      {
        command = [ "noctalia-shell" ];
      }
      {
        command = runAfterTray "${discord} --start-minimized";
      }
      {
        command = runAfterTray "steam -silent";
      }
      {
        command = [ "hypridle" ];
      }
      {
        command = [ "kdeconnectd" ];
      }
      {
        command = [ "XDG_MENU_PREFIX=plasma- kbuildsycoca6" ];
      }
      {
        command = [ "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1" ];
      }
    ];
  };
}
