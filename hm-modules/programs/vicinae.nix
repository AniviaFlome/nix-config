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
      window = {
        csd = true;
        opacity = 0.95;
        rounding = 10;
      };
      popToRootOnClose = false;
      rootSearch.searchFiles = false;
      closeOnFocusLoss = true;
      faviconService = "twenty";
    };
  };

  xdg.configFile."vicinae/vicinae.json".force = true;
}
