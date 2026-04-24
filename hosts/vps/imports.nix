{
  imports = [
    # Security
    ../../modules/security/fail2ban.nix
    ../../modules/security/firewall.nix
    # Server
    ../../modules/server/glances.nix
    ../../modules/server/freshrss.nix
    ../../modules/server/traefik.nix
    # System
    ../../modules/system/nix.nix
    ../../modules/system/autoupdate.nix
    ../../modules/system/nh.nix
    ../../modules/system/shell.nix
    ../../modules/system/sops-nix.nix
  ];
}
