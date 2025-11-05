{
  programs.vicinae = {
    enable = true;
    systemd.autoStart = true;
    settings = {
      theme.name = "catppuccin-mocha";
    };
  };
}
