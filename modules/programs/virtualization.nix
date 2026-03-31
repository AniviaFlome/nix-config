{
  pkgs,
  username,
  ...
}:
{
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      package = pkgs.libvirt;
      qemu = {
        package = pkgs.qemu;
        swtpm = {
          enable = true;
        };
      };
    };
  };

  users.users.${username}.extraGroups = [ "libvirtd" ];

  services.spice-vdagentd.enable = true;

  programs.virt-manager.enable = true;
}
