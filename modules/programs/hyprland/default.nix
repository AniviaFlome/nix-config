{
  flake.modules.nixos.hyprland = {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
  };

  flake.modules.homeManager.hyprland =
    { pkgs, ... }:
    {
      imports = [
        ./autostart.nix
        ./keybinds.nix
        ./settings.nix
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        xwayland.enable = true;
        plugins = [ ];
      };

      home.packages = with pkgs; [
        hyprland-qt-support
        grimblast
      ];
    };
}
