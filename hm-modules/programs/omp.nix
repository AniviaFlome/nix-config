{
  pkgs,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
  settings = {
    providers.webSearchOrder = [ ];
    symbolPreset = "nerd";
    composer.shape = "claude";
    theme.dark = "dark-catppuccin";
    setupVersion = 2;
    computer.enabled = true;
    github.enabled = true;
    security.enabled = true;
    statusLine = {
      preset = "default";
      separator = "powerline";
    };
  };
in
{
  home.packages = [ pkgs.omp ];

  home.file.".omp/agent/config.yml" = {
    force = true;
    source = yamlFormat.generate "omp-config.yml" settings;
  };
}
