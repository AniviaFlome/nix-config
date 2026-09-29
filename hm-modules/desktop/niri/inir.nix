{
  inputs,
  ...
}:
{
  imports = [ inputs.inir.homeModules.default ];

  programs.inir = {
    enable = true;
    service = {
      enable = true;
      compositor = "niri";
    };
  };

  programs.niri.settings.binds = {
    "Mod+Space" = {
      repeat = false;
      action.spawn = [
        "inir"
        "overview"
        "toggle"
      ];
    };

    "Mod+G".action.spawn = [
      "inir"
      "clipboard"
      "toggle"
    ];
    "Mod+Comma".action.spawn = [
      "inir"
      "settings"
    ];
    "Mod+Slash".action.spawn = [
      "inir"
      "cheatsheet"
      "toggle"
    ];
    "Mod+Shift+W".action.spawn = [
      "inir"
      "panelFamily"
      "cycle"
    ];

    "Mod+Alt+L" = {
      allow-when-locked = true;
      action.spawn = [
        "inir"
        "lock"
        "activate"
      ];
    };

    "Mod+Shift+S".action.spawn = [
      "inir"
      "region"
      "screenshot"
    ];
    "Mod+Shift+X".action.spawn = [
      "inir"
      "region"
      "ocr"
    ];
    "Mod+Shift+A".action.spawn = [
      "inir"
      "region"
      "search"
    ];
  };
}
