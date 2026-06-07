{
  flake.modules.nixos.fail2ban = {
    services.fail2ban.enable = true;
  };
  flake.modules.nixos.fail2ban-vps = {
    services.fail2ban.enable = true;
  };
}
