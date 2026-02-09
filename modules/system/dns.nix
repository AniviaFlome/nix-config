let
  StateDirName = "dnscrypt-proxy-state";
  StatePath = "/var/lib/${StateDirName}";
  CacheDirName = "dnscrpt-proxy-cache";
  CachePath = "/var/lib/${CacheDirName}";
in
{
  networking = {
    networkmanager = {
      dns = "none";
    };
    nameservers = [
      "127.0.0.1"
      "::1"
    ];
  };

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = [
        "127.0.0.1:53"
        "[::1]:53"
      ];
      ipv6_servers = true;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = false;

      # Bootstrap resolvers - plain DNS IPs to resolve DoH hostnames initially
      bootstrap_resolvers = [
        "9.9.9.9:53"
        "149.112.112.112:53"
      ];

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        cache_file = "${StatePath}/public-resolvers.md";
      };

      server_names = [
        "quad9-doh-ip4-port443-filter-pri"
        "quad9-doh-ip6-port443-filter-pri"
      ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = StatePath;
    CacheDirectory = CachePath;
  };
}
