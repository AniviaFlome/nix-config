{
  inputs,
  pkgs,
  ...
}:
{
  xdg.configFile."hypr/hyprqt6engine.conf" = {
    text = ''
      theme {
        color_scheme = ${pkgs.catppuccin-qt5ct}/share/qt5ct/colors/catppuccin-mocha-mauve.conf
        style = breeze
      }
    '';
  };

  home.packages = [
    inputs.hyprqt6engine.packages.${pkgs.stdenv.hostPlatform.system}.hyprqt6engine
  ];
}
