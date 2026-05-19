{
  config,
  lib,
  ...
}:
let
  cfg = config.services.waha;
in
{
  options.services.waha = {
    enable = lib.mkEnableOption "WAHA - WhatsApp HTTP API";

    image = lib.mkOption {
      type = lib.types.str;
      default = "devlikeapro/waha:latest";
      description = "Docker image to use. Use devlikeapro/waha-plus:latest for Plus features.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port to expose WAHA on (bound to localhost).";
    };

    engine = lib.mkOption {
      type = lib.types.enum [
        "WEBJS"
        "NOWEB"
        "GOWS"
      ];
      default = "WEBJS";
      description = "Default WhatsApp engine.";
    };

    apiKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the WAHA API key. Takes precedence over apiKey.";
    };

    apiKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "WAHA API key. Prefer apiKeyFile for secret management.";
    };

    dashboardUsername = lib.mkOption {
      type = lib.types.str;
      default = "admin";
      description = "Dashboard login username.";
    };

    dashboardPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the dashboard password.";
    };

    dashboardPassword = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Dashboard login password. Prefer dashboardPasswordFile for secret management.";
    };

    swaggerEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Swagger API documentation.";
    };

    swaggerUsername = lib.mkOption {
      type = lib.types.str;
      default = "admin";
      description = "Swagger UI username.";
    };

    swaggerPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the Swagger password.";
    };

    swaggerPassword = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Swagger UI password. Prefer swaggerPasswordFile for secret management.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ];
      default = "info";
      description = "Log level.";
    };

    logFormat = lib.mkOption {
      type = lib.types.enum [
        "JSON"
        "PRETTY"
      ];
      default = "JSON";
      description = "Log output format.";
    };

    namespace = lib.mkOption {
      type = lib.types.str;
      default = "all";
      description = "WAHA namespace for session storage across engines.";
    };

    baseUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Public base URL for the WAHA instance (used for webhooks, media URLs).";
    };

    printQr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Print QR codes in logs.";
    };

    startSessions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of session names to start automatically on launch.";
    };

    restartAllSessions = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Restart all STOPPED sessions on container restart.";
    };

    mediaStorage = lib.mkOption {
      type = lib.types.enum [
        "LOCAL"
        "S3"
        "POSTGRESQL"
      ];
      default = "LOCAL";
      description = "Media storage backend.";
    };

    s3 = {
      region = lib.mkOption {
        type = lib.types.str;
        default = "eu-west-2";
        description = "S3 region.";
      };
      bucket = lib.mkOption {
        type = lib.types.str;
        default = "waha";
        description = "S3 bucket name.";
      };
      accessKeyId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "S3 access key ID. Prefer accessKeyIdFile for secret management.";
      };
      accessKeyIdFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the S3 access key ID.";
      };
      secretAccessKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "S3 secret access key. Prefer secretAccessKeyFile for secret management.";
      };
      secretAccessKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the S3 secret access key.";
      };
      endpoint = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "S3 endpoint URL (not required for AWS S3).";
      };
      forcePathStyle = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Force path-style S3 URLs (set to True for MinIO).";
      };
      proxyFiles = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Proxy media files through WAHA. Set to True or False.";
      };
    };

    sessionStorage = lib.mkOption {
      type = lib.types.enum [
        "LOCAL"
        "POSTGRESQL"
        "MONGODB"
      ];
      default = "LOCAL";
      description = "Session storage backend.";
    };

    sessionPostgresqlUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "PostgreSQL URL for session storage.";
    };

    sessionMongoUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "MongoDB URL for session storage.";
    };

    webhookUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Global webhook URL.";
    };

    webhookEvents = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Global webhook events (comma-separated or *).";
    };

    proxyServer = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Proxy server in host:port format.";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra environment variables for the WAHA container.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the WAHA port in the firewall. Disable when using a reverse proxy.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/waha";
      description = "Directory for persistent WAHA data.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root -"
      "d ${cfg.dataDir}/sessions 0755 root root -"
      "d ${cfg.dataDir}/media 0755 root root -"
    ];

    virtualisation.oci-containers.containers.waha = {
      inherit (cfg) image;
      ports = [ "127.0.0.1:${toString cfg.port}:3000/tcp" ];
      volumes = [
        "${cfg.dataDir}/sessions:/app/.sessions"
        "${cfg.dataDir}/media:/app/.media"
      ];
      environment = {
        WHATSAPP_DEFAULT_ENGINE = cfg.engine;
        WAHA_NAMESPACE = cfg.namespace;
        WAHA_DASHBOARD_ENABLED = "True";
        WAHA_DASHBOARD_USERNAME = cfg.dashboardUsername;
        WHATSAPP_SWAGGER_ENABLED = if cfg.swaggerEnabled then "True" else "False";
        WAHA_LOG_LEVEL = cfg.logLevel;
        WAHA_LOG_FORMAT = cfg.logFormat;
        WAHA_PRINT_QR = if cfg.printQr then "True" else "False";
        WAHA_MEDIA_STORAGE = cfg.mediaStorage;
        WHATSAPP_FILES_LIFETIME = "0";
        WHATSAPP_FILES_FOLDER = "/app/.media";
        WAHA_ZIPPER = "ZIPUNZIP";
        WAHA_RESTART_ALL_SESSIONS = if cfg.restartAllSessions then "True" else "False";
      }
      // lib.optionalAttrs (cfg.apiKey != null) { WAHA_API_KEY = cfg.apiKey; }
      // lib.optionalAttrs (cfg.dashboardPassword != null) {
        WAHA_DASHBOARD_PASSWORD = cfg.dashboardPassword;
      }
      // lib.optionalAttrs (cfg.swaggerPassword != null) {
        WHATSAPP_SWAGGER_PASSWORD = cfg.swaggerPassword;
      }
      // lib.optionalAttrs (cfg.swaggerUsername != "admin") {
        WHATSAPP_SWAGGER_USERNAME = cfg.swaggerUsername;
      }
      // lib.optionalAttrs (cfg.baseUrl != null) { WAHA_BASE_URL = cfg.baseUrl; }
      // lib.optionalAttrs (cfg.startSessions != [ ]) {
        WHATSAPP_START_SESSION = lib.concatStringsSep "," cfg.startSessions;
      }
      // lib.optionalAttrs (cfg.sessionStorage == "POSTGRESQL" && cfg.sessionPostgresqlUrl != null) {
        WHATSAPP_SESSIONS_POSTGRESQL_URL = cfg.sessionPostgresqlUrl;
      }
      // lib.optionalAttrs (cfg.sessionStorage == "MONGODB" && cfg.sessionMongoUrl != null) {
        WHATSAPP_SESSIONS_MONGO_URL = cfg.sessionMongoUrl;
      }
      // lib.optionalAttrs (cfg.mediaStorage == "S3") {
        WAHA_MEDIA_STORAGE = "S3";
        WAHA_S3_REGION = cfg.s3.region;
        WAHA_S3_BUCKET = cfg.s3.bucket;
      }
      // lib.optionalAttrs (cfg.mediaStorage == "S3" && cfg.s3.accessKeyId != null) {
        WAHA_S3_ACCESS_KEY_ID = cfg.s3.accessKeyId;
      }
      // lib.optionalAttrs (cfg.mediaStorage == "S3" && cfg.s3.secretAccessKey != null) {
        WAHA_S3_SECRET_ACCESS_KEY = cfg.s3.secretAccessKey;
      }
      // lib.optionalAttrs (cfg.mediaStorage == "S3" && cfg.s3.endpoint != null) {
        WAHA_S3_ENDPOINT = cfg.s3.endpoint;
      }
      // lib.optionalAttrs (cfg.mediaStorage == "S3" && cfg.s3.forcePathStyle != null) {
        WAHA_S3_FORCE_PATH_STYLE = cfg.s3.forcePathStyle;
      }
      // lib.optionalAttrs (cfg.mediaStorage == "S3" && cfg.s3.proxyFiles != null) {
        WAHA_S3_PROXY_FILES = cfg.s3.proxyFiles;
      }
      // lib.optionalAttrs (cfg.webhookUrl != null) {
        WHATSAPP_HOOK_URL = cfg.webhookUrl;
      }
      // lib.optionalAttrs (cfg.webhookEvents != null) {
        WHATSAPP_HOOK_EVENTS = cfg.webhookEvents;
      }
      // lib.optionalAttrs (cfg.proxyServer != null) {
        WHATSAPP_PROXY_SERVER = cfg.proxyServer;
      }
      // cfg.extraEnvironment;

      environmentFiles =
        lib.optional (cfg.apiKeyFile != null) cfg.apiKeyFile
        ++ lib.optional (cfg.dashboardPasswordFile != null) cfg.dashboardPasswordFile
        ++ lib.optional (cfg.swaggerPasswordFile != null) cfg.swaggerPasswordFile
        ++ lib.optional (cfg.mediaStorage == "S3" && cfg.s3.accessKeyIdFile != null) cfg.s3.accessKeyIdFile
        ++ lib.optional (
          cfg.mediaStorage == "S3" && cfg.s3.secretAccessKeyFile != null
        ) cfg.s3.secretAccessKeyFile;

      log-driver = "json-file";
      log-opts = {
        max-size = "100m";
        max-file = "10";
      };

      extraOptions = [
        "--dns=1.1.1.1"
        "--dns=8.8.8.8"
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
