{
  pkgs,
  username,
  ...
}:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      package = pkgs.libvirt;
      qemu = {
        package = pkgs.qemu;
        swtpm = {
          enable = true;
          package = pkgs.swtpm;
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.${username}.extraGroups = [ "libvirtd" ];
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;


  environment.systemPackages = with pkgs; [
    winboat
    freerdp
  ];
}
