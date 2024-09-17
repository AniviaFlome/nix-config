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
  };
}
