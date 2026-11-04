{
  pkgs,
  ...
}:
{
  wayland.windowManager.mango.autostart_sh = ''
    kdeconnectd &
    ${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1 &
    dms run &
  '';
}
