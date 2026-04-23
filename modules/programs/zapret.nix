{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.zapret = {
    enable = !config.networking.nftables.enable;
    configureFirewall = true;
    params = [
      "--dpi-desync=fake"
      "--dpi-desync-ttl=3"
    ];
  };

  systemd.services.zapret = lib.mkIf config.networking.nftables.enable (
    let
      nftRules = pkgs.writeText "zapret-nft.rules" ''
        table inet zapret {
          chain output {
            type filter hook output priority mangle; policy accept;
            meta oif lo accept
            ip daddr { 10.0.0.0/8, 100.64.0.0/10, 169.254.0.0/16, 172.16.0.0/12, 192.168.0.0/16, 192.168.122.0/24, 172.18.0.0/16 } accept
            ip6 daddr { fc00::/7, fe80::/10, ::1 } accept
            tcp dport { 80, 443 } queue num 200 bypass
          }
        }
      '';
    in
    {
      description = "DPI bypass service";
      after = [
        "network.target"
        "nftables.service"
      ];
      wants = [ "nftables.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.nftables ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.zapret}/bin/nfqws ${
          builtins.concatStringsSep " " (config.services.zapret.params ++ [ "--qnum=200" ])
        }";
        ExecStartPre = "${pkgs.nftables}/bin/nft -f ${nftRules}";
        ExecStopPost = "-${pkgs.nftables}/bin/nft delete table inet zapret";
        Restart = "always";
        RestartSec = "5";
      };
    }
  );
}
