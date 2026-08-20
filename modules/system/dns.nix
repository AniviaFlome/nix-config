{
  networking = {
    networkmanager.dns = "systemd-resolved";
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = "9.9.9.9 149.112.112.112";
      FallbackDNS = "9.9.9.9 149.112.112.112";
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
      MulticastDNS = "yes";
      LLMNR = "yes";
    };
  };
}
