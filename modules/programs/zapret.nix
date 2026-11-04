{
  services.zapret2 = {
    enable = true;
    profiles = {
      https = {
        priority = 100;
        parameters = [
          "--filter-tcp=443"
          "--payload=tls_client_hello"
          "--lua-desync=fake:blob=fake_default_tls:ip_ttl=3:repeats=1"
        ];
      };
      http = {
        priority = 200;
        parameters = [
          "--filter-tcp=80"
          "--payload=http_req"
          "--lua-desync=fake:blob=fake_default_http:ip_ttl=3:repeats=1"
        ];
      };
    };
    firewall = {
      tcpPorts = [ 80 443 ];
      udpPorts = [ ];
    };
  };
}
