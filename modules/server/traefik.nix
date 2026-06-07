{
  flake.modules.nixos.traefik = {
    services.traefik = {
      enable = true;
      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
            };
          };
          websecure = {
            address = ":443";
            http.tls.certResolver = "letsencrypt";
          };
        };
        certificatesResolvers.letsencrypt.acme = {
          email = "your-email@example.com";
          storage = "/var/lib/traefik/acme.json";
          httpChallenge.entryPoint = "web";
        };
        api.dashboard = true;
      };
      dynamicConfigOptions = {
        http = {
          routers = {
            glances = {
              rule = "Host(`example.com`)";
              service = "glances";
              entryPoints = [ "websecure" ];
            };
            freshrss = {
              rule = "Host(`rss.example.com`)";
              service = "freshrss";
              entryPoints = [ "websecure" ];
            };
            waha = {
              rule = "Host(`waha.example.com`)";
              service = "waha";
              entryPoints = [ "websecure" ];
            };
            coolify = {
              rule = "Host(`coolify.example.com`)";
              service = "coolify";
              entryPoints = [ "websecure" ];
            };
            traefik-dashboard = {
              rule = "Host(`traefik.example.com`)";
              service = "api@internal";
              entryPoints = [ "websecure" ];
              middlewares = [ "auth" ];
            };
          };
          services = {
            glances.loadBalancer.servers = [
              { url = "http://localhost:61208"; }
            ];
            freshrss.loadBalancer.servers = [
              { url = "http://localhost:8080"; }
            ];
            coolify.loadBalancer.servers = [
              { url = "http://localhost:8000"; }
            ];
            waha.loadBalancer.servers = [
              { url = "http://localhost:3000"; }
            ];
          };
          middlewares = {
            auth.basicAuth.users = [
              "admin:$apr1$..."
            ];
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    systemd.tmpfiles.rules = [
      "f /var/lib/traefik/acme.json 0600 traefik traefik -"
    ];
  };
}
