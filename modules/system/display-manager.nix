{ catppuccin, ... }:

{
  services.displayManager = {
    sddm = {
      enable = true;
      autoNumlock = true;
      catppuccin.enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
    };
    defaultSession = "plasma";
    autoLogin = {
        enable = true;
        user = "aniviaflome";
    };
  };
}
