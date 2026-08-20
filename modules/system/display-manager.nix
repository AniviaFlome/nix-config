{
  username,
  ...
}:
{
  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    autoLogin = {
      enable = false;
      user = username;
    };
  };
}
