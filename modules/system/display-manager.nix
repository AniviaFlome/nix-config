{
  username,
  ...
}:
{
  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    defaultSession = null;
    autoLogin = {
      enable = false;
      user = username;
    };
  };
}
