{ pkgs, inputs, ... }:

{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  home.packages = with pkgs; [
    (catppuccin-kde.override {
      flavour = [ "mocha" ];
      accents = [ "mauve" ];
      winDecStyles = [ "classic" ];
    })
  ];

  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "Bibata-Modern-Ice";
      iconTheme = "Papirus-Dark";
      wallpaper = "/mnt/hdd/wallpaper/wallpaper.jpg";
    };

    hotkeys.commands."launch-terminal" = {
      name = "Launch Terminal";
      key = "Meta+Q";
      command = "kitty";
    };
    hotkeys.commands."launch-file-manager" = {
      name = "Launch File Manager";
      key = "Meta+E";
      command = "dolphin";
    };

    panels = [
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.applicationlauncher"
          "org.kde.plasma.pager"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    shortcuts = {
      kwin = {
        "Close Window" = "Meta+C";
        "Maximize Window" = "Meta+F";
      };
    };
  };
}
