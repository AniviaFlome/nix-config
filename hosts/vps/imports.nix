{
  imports = [
    # Security
    ../../modules/security/fail2ban.nix
    ../../modules/security/firewall.ncfix
    # Server
    ../../modules/server/glances.nix
    ../../modules/server/freshrss.nix
    ../../modules/server/traefik.nix
    # System
    ../../modules/system/autoupdate.nix
    ../../modules/system/nh.nix
    ../../modules/system/shell.nix
    ../../modules/system/sops-nix.nix
  ];
}
