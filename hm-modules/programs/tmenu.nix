{
  inputs,
  ...
}:
{
  imports = [ inputs.tmenu.homeManagerModules.default ];

  programs.tmenu = {
    enable = true;

    display = {
      centered = true;
      width = 60;
      height = 10;
      title = "Tmenu";
      figlet = {
        enable = true;
        font = "standard";
      };
      theme = {
        name = "catppuccin-mocha";
      };
    };

    menuItems = {
      "Browser" = "firefox";
      "System" = "submenu:System";
      "Terminal" = "alacritty";
    };

    submenu.System = {
      "File Manager" = "thunar";
      "System Monitor" = "htop";
      "Task Manager" = "gnome-system-monitor";
    };
  };
}
