{
  pkgs,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "noctalia-shell"
      "hypridle"
      "XDG_MENU_PREFIX=plasma- kbuildsycoca6"
      "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1"
    ];
  };
}
