{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.programs.steam-compat-tools;
in
{
  options.programs.steam-compat-tools = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.programs.steam.extraCompatPackages != [ ];
      description = "Symlink Steam compatibility tools to a shared directory for use by Lutris, Heroic, and other launchers.";
    };
    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = osConfig.programs.steam.extraCompatPackages;
      description = "List of compatibility tool packages to symlink.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = lib.listToAttrs (
      map (pkg: {
        name = ".steam/steam/compatibilitytools.d/${lib.getName pkg}";
        value.source = pkg.steamcompattool;
      }) (lib.filter (pkg: pkg ? steamcompattool) cfg.packages)
    );
  };
}
