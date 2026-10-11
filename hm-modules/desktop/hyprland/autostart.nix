{
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
      hl.exec_cmd("dms run")
      hl.exec_cmd("kdeconnectd")
      hl.exec_cmd("XDG_MENU_PREFIX=plasma- kbuildsycoca6")
      hl.exec_cmd("${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1")
    end)
  '';
}
