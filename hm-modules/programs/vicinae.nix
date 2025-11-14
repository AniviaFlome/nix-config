{
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      theme.name = "catppuccin-mocha";
    };
  };

  xdg.configFile."vicinae/vicinae.json".force = true;
}
