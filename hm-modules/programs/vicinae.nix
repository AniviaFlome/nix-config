{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
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
}
