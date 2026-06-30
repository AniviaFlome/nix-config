{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.kopuz;
  configFormat = pkgs.formats.json { };
in
{
  options.programs.kopuz = {
    enable = lib.mkEnableOption "kopuz";

    package = lib.mkPackageOption pkgs "kopuz" { };

    activeSource = lib.mkOption {
      type = lib.types.str;
      default = "Local";
      description = "Active media source name or 'Local'.";
    };

    musicDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of local music directory paths.";
    };

    theme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Theme name for kopuz.";
    };

    discordPresence = {
      enable = lib.mkEnableOption "Discord rich presence for kopuz" // {
        default = true;
      };
      showWhenPaused = lib.mkEnableOption "Discord rich presence when playback is paused";
    };

    sortOrder = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default sort order for the library.";
    };

    artistViewOrder = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default sort order for the artist view.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."kopuz/config.json" = lib.mkIf (cfg.musicDirectories != [ ] || cfg.theme != null) {
      source = configFormat.generate "kopuz-config" (
        lib.filterAttrs (_: v: v != null && v != [ ]) {
          active_source = cfg.activeSource;
          music_directory = cfg.musicDirectories;
          inherit (cfg) theme;
          discord_presence = cfg.discordPresence.enable;
          discord_presence_paused = cfg.discordPresence.showWhenPaused;
          sort_order = cfg.sortOrder;
          artist_view_order = cfg.artistViewOrder;
        }
      );
    };
  };
}
