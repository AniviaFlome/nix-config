{
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];
      FallbackDNS = [
        "9.9.9.10#dns.quad9.net"
        "1.1.1.1#cloudflare-dns.com"
      ];
    };
  };

  networking.networkmanager = {
    dns = "systemd-resolved";
  };
}
