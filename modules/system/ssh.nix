{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
      };
    };
  };
}
