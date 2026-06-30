{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.steam.millennium;
  configFormat = pkgs.formats.json { };
in
{
  options.programs.steam.millennium = {
    enable = lib.mkEnableOption "Millennium Steam modding framework configuration";

    accentColor = lib.mkOption {
      type = lib.types.str;
      default = "#cba6f7";
      description = "Accent color for Millennium UI (hex color).";
    };

    injectCSS = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether Millennium should inject custom CSS.";
    };

    injectJavascript = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether Millennium should inject custom JavaScript.";
    };

    updateChannel = lib.mkOption {
      type = lib.types.enum [
        "stable"
        "beta"
        "nightly"
      ];
      default = "stable";
      description = "Millennium update channel.";
    };

    checkForUpdates = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to check for Millennium updates.";
    };

    checkForPluginAndThemeUpdates = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to check for plugin and theme updates.";
    };

    showUpdateNotifications = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to show theme/plugin update notifications.";
    };

    activeTheme = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Name of the active Millennium theme.";
    };

    enabledPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of enabled Millennium plugin names.";
    };

    quickCSS = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      description = "Custom CSS to inject via Millennium's quick CSS feature.";
    };

    allowedScripts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to allow theme JavaScript execution.";
    };

    allowedStyles = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to allow theme CSS injection.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."millennium/config.json" = {
      source = configFormat.generate "millennium-config" {
        general = {
          inherit (cfg) accentColor;
          checkForMillenniumUpdates = cfg.checkForUpdates;
          inherit (cfg) checkForPluginAndThemeUpdates;
          inherit (cfg) injectCSS;
          inherit (cfg) injectJavascript;
          millenniumUpdateChannel = cfg.updateChannel;
          shouldShowThemePluginUpdateNotifications = cfg.showUpdateNotifications;
        };
        plugins = {
          inherit (cfg) enabledPlugins;
        };
        themes = lib.optionalAttrs (cfg.activeTheme != null) {
          inherit (cfg) activeTheme;
          inherit (cfg) allowedScripts;
          inherit (cfg) allowedStyles;
        };
      };
    };

    xdg.configFile."millennium/quick.css" = lib.mkIf (cfg.quickCSS != null) {
      text = cfg.quickCSS;
    };
  };
}
