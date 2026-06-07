{
  flake.modules.nixos.n8n = {
    services.n8n = {
      enable = true;
      openFirewall = true;
    };
  };
}
