{
  pkgs,
  video,
  ...
}:
{
  home.packages = with pkgs; [ nyaa ];

  xdg.configFile."nyaa/config.toml" = {
    force = true;
    text = ''
      theme = "Catppuccin Mocha"
      default_source = "Nyaa"
      download_client = "RunCommand"
      timeout = 30
      scroll_padding = 3
      cursor_padding = 4
      save_config_on_change = true
      hot_reload_config = true

      [client.command]
      cmd = "${video} {torrent}"
      shell_cmd = "bash -c"
    '';
  };

  xdg.configFile."nyaa/themes/catppuccin-mocha.toml" = {
    force = true;
    text = ''
      name = "Catppuccin Mocha"
      bg = "#11111b"
      fg = "#cdd6f4"
      border = "Rounded"
      border_color = "#6e738d"
      border_focused_color = "#cba6f7"
      hl_bg = "#6e738d"
      solid_bg = "#a6e3a1"
      solid_fg = "#181926"
      trusted = "#a6e3a1"
      remake = "#f38ba8"
    '';
  };
}
