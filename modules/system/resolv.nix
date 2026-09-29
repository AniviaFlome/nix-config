{
  config,
  ...
}:
let
  ssid = "ATATEPEWIFI";
in
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
      DNSOverTLS = "opportunistic";
      Domains = [ "~." ];
      DNSSEC = "no";
    };
  };

  networking.networkmanager = {
    dns = "systemd-resolved";

    ensureProfiles = {
      environmentFiles = [
        config.sops.secrets."wifi-psk".path
      ];

      profiles.${ssid} = {
        connection = {
          id = ssid;
          uuid = "025ce441-6fbe-4d34-93e6-d1be7f50e3d6";
          type = "wifi";
          autoconnect = true;
          autoconnect-priority = 10;
          dns-over-tls = 0; # 0 = never use DNS-over-TLS on this network.
        };
        wifi = {
          mode = "infrastructure";
          inherit ssid;
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PSK_ATATEPEWIFI";
        };
        ipv4.method = "auto";
        ipv6.method = "auto";
      };
    };
  };
}
