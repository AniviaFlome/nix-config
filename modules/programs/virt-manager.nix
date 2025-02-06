{ pkgs-stable, username, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = with pkgs-stable; [ OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.${username}.extraGroups = [ "libvirtd" ];
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs-stable; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
  ];
}
