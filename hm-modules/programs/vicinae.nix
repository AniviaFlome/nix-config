{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      theme = {
        name = "catppuccin-mocha";
        iconTheme = "Catppuccin Mocha Mauve";
      };
      closeOnFocusLoss = true;
      faviconService = "google";
    };
  };

  xdg.configFile."vicinae/vicinae.json".force = true;
}
