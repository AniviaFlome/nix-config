{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [ kopuz-flake ];

  xdg.configFile."kopuz/settings.toml".source =
    (pkgs.formats.toml { }).generate "kopuz-settings.toml"
      {
        theme = "custom-catppuccin_mocha_mauve";

        custom_themes.custom-catppuccin_mocha_mauve = {
          name = "Catppuccin_Mocha_Mauve";
          vars = {
            accent = "#cba6f7";
            accent-alt = "#7287fd";
            accent-deep = "#11111b";
            accent-soft = "#f5c2e7";
            bg = "#1e1e2e";
            danger = "#f38ba8";
            highlight = "#f5e0dc";
            highlight-dark = "#b4befe";
            progress = "#a6e3a1";
            raised = "#181825";
            surface = "#585b70";
            text = "#cdd6f4";
            text-muted = "#bac2de";
          };
        };
      };
}
