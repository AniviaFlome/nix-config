{
  flake.modules.nixos.oom = {
    systemd.oomd.enable = true;
  };
}
