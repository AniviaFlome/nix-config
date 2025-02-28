{ username, ... }:

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
    defaultSession = "plasma";
    autoLogin = {
        enable = false;
        user = "${username}";
    };
  };
}
