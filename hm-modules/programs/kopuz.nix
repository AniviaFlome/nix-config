{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ kopuz-flake ];

  xdg.configFile."kopuz/settings.toml".source =
    (pkgs.formats.toml { }).generate "kopuz-settings.toml"
      {
        theme = "catppuccin-mocha";
      };
}
