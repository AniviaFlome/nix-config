{ config, lib, pkgs, ... }:
{
  services.traefik = {
    enable = lib.mkDefault true;
    
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
        email = "your-email@example.com"; # Change this
        storage = "/var/lib/traefik/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          # Glances (Homepage/Monitoring)
          glances = {
            rule = "Host(`example.com`)"; # Change to your domain
            service = "glances";
            entryPoints = [ "websecure" ];
          };
          
          # FreshRSS
          freshrss = {
            rule = "Host(`rss.example.com`)"; # Change to your domain
            service = "freshrss";
            entryPoints = [ "websecure" ];
          };
          
          # Coolify
          coolify = {
            rule = "Host(`coolify.example.com`)"; # Change to your domain
            service = "coolify";
            entryPoints = [ "websecure" ];
          };

          # Traefik Dashboard
          traefik-dashboard = {
            rule = "Host(`traefik.example.com`)"; # Change to your domain
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
        };

        middlewares = {
          # Basic auth for Traefik dashboard
          # Generate password with: htpasswd -nb admin password
          auth.basicAuth.users = [
            "admin:$apr1$..." # Replace with your hashed password
          ];
        };
      };
    };
  };

  # Open HTTP and HTTPS ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Create acme.json with correct permissions
  systemd.tmpfiles.rules = [
    "f /var/lib/traefik/acme.json 0600 traefik traefik -"
  ];
}
