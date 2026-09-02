let
  hasIPv6Internet = false;
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

      ipv6_servers = hasIPv6Internet;
      block_ipv6 = !hasIPv6Internet;

      require_dnssec = false;
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
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
      };

      fallback_resolvers = [
        "9.9.9.9:53"
        "1.1.1.1:53"
        "8.8.8.8:53"
      ];

      server_names = [
        "quad9-doh-ip4-port443-filter-pri"
        "quad9-doh-ip6-port443-filter-pri"
        "mullvad-doh"
        "adguard-dns-doh"
      ];
    };
  };
}
