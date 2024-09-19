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
      settings = {
        CursorTheme = {
          Cursor = "catppuccin-mocha-mauve-cursors";
        };
        InputMethod = {
          name = "none";
        };
      };
    };
  };
}
