{
  config,
  lib,
  osConfig ? throw "steam-compat-tools: osConfig is not available. The module will be ignored.",
  ...
}:
let
  cfg = config.programs.steam-compat-tools;
  compatPackages = osConfig.programs.steam.extraCompatPackages or [ ];
in
{
  options.programs.steam-compat-tools = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = compatPackages != [ ];
      description = "Symlink Steam compatibility tools to a shared directory for use by Lutris, Heroic, and other launchers.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.listToAttrs (
      map (pkg: {
        name = ".steam/steam/compatibilitytools.d/${lib.getName pkg}";
        value.source = pkg.steamcompattool;
      }) (lib.filter (pkg: pkg ? steamcompattool) compatPackages)
    );
  };
}
