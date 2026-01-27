{ lib, ... }:
{
  services.freshrss = {
    enable = lib.mkDefault false;
    baseUrl = "https://rss.example.com"; # Change to your domain
    defaultUser = "admin";
    # Password should be set via sops-nix or manually after first setup
    database.type = "sqlite";
  };

  # FreshRSS runs on port 8080 by default
  # Access via Traefik reverse proxy
}
