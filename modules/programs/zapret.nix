{
  config,
  ...
}:
{
  services.zapret = {
    enable = true;
    configureFirewall = !config.networking.nftables.enable;
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
    ];
  };
}
