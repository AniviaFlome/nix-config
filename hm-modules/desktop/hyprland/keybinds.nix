{
  clipboard,
  file,
  launcher,
  terminal,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    bind = [
      "$mainMod, C, killactive,"
      "$mainMod, F, fullscreen, 1"
      "$mainMod SHIFT, F, fullscreen, 0"
      "$mainMod, V, togglefloating,"
      "$mainMod, Q, togglegroup,"

      "$mainMod, T, exec, ${terminal}"
      "$mainMod, E, exec, ${file}"
      "$mainMod, B, exec, power-profiles-switch"
      "$mainMod, Space, exec, ${launcher}"
      "$mainMod, H, exec, ${clipboard}"

      "$mainMod, P, exec, grimblast copy area"
      "$mainMod SHIFT, P, exec, grimblast copy screen"
      "$mainMod CTRL, P, exec, grimblast copy active"

      "$mainMod, Up, layoutmsg, focus u"
      "$mainMod, Left, layoutmsg, focus l"
      "$mainMod, Down, layoutmsg, focus d"
      "$mainMod, Right, layoutmsg, focus r"

      "$mainMod, W, workspace, -1"
      "$mainMod, A, layoutmsg, focus l"
      "$mainMod, S, workspace, +1"
      "$mainMod, D, layoutmsg, focus r"

      "$mainMod SHIFT, W, movetoworkspace, -1"
      "$mainMod SHIFT, A, layoutmsg, swapcol l"
      "$mainMod SHIFT, S, movetoworkspace, +1"
      "$mainMod SHIFT, D, layoutmsg, swapcol r"

      "$mainMod SHIFT, Up, movewindow, u"
      "$mainMod SHIFT, Left, layoutmsg, move -col"
      "$mainMod SHIFT, Down, movewindow, d"
      "$mainMod SHIFT, Right, layoutmsg, move +col"

      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"

      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"

      "$mainMod, mouse_down, layoutmsg, focus r"
      "$mainMod, mouse_up, layoutmsg, focus l"
      "$mainMod SHIFT, mouse_down, workspace, +1"
      "$mainMod SHIFT, mouse_up, workspace, -1"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
