{
  config,
  file,
  terminal,
  ...
}:

{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    "Mod+C".action = close-window;
    "Mod+E".action.spawn = "${file}";
    "Mod+T".action.spawn = "${terminal}";
    "Mod+G".action = toggle-overview;
    "Mod+Space".action.spawn = [
      "noctalia-shell"
      "ipc"
      "call"
      "launcher"
      "toggle"
    ];

    "Mod+F".action = maximize-column;
    "Mod+V".action = toggle-window-floating;

    "Alt+Tab".action.spawn = [
      "niriswitcherctl"
      "show"
      "--window"
    ];
    "Alt+Tab".repeat = false;

    "Mod+P".action = screenshot;
    "Mod+Shift+P".action.screenshot-screen = [ ];
    "Mod+Ctrl+P".action = screenshot-window;

    "Mod+Left".action = focus-column-left;
    "Mod+Down".action = focus-window-down;
    "Mod+Up".action = focus-window-up;
    "Mod+Right".action = focus-column-right;
    "Mod+A".action = focus-column-left;
    "Mod+D".action = focus-column-right;
    "Mod+S".action = focus-window-down;
    "Mod+W".action = focus-window-up;

    "Mod+1".action.focus-workspace = 1;
    "Mod+2".action.focus-workspace = 2;
    "Mod+3".action.focus-workspace = 3;
    "Mod+4".action.focus-workspace = 4;
    "Mod+5".action.focus-workspace = 5;
    "Mod+6".action.focus-workspace = 6;
    "Mod+7".action.focus-workspace = 7;
    "Mod+8".action.focus-workspace = 8;
    "Mod+9".action.focus-workspace = 9;
    "Mod+Shift+1".action.move-column-to-workspace = 1;
    "Mod+Shift+2".action.move-column-to-workspace = 2;
    "Mod+Shift+3".action.move-column-to-workspace = 3;
    "Mod+Shift+4".action.move-column-to-workspace = 4;
    "Mod+Shift+5".action.move-column-to-workspace = 5;
    "Mod+Shift+6".action.move-column-to-workspace = 6;
    "Mod+Shift+7".action.move-column-to-workspace = 7;
    "Mod+Shift+8".action.move-column-to-workspace = 8;
    "Mod+Shift+9".action.move-column-to-workspace = 9;
  };
}
