{ pkgs-stable, username, system, winapps, ... }:

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

  environment.systemPackages = [
    pkgs-stable.virt-viewer
    pkgs-stable.spice
    pkgs-stable.spice-gtk
    pkgs-stable.spice-protocol
    pkgs-stable.virtio-win
    pkgs-stable.win-spice
    pkgs-stable.quickemu
    pkgs-stable.quickgui
    winapps.packages."${system}".winapps
    winapps.packages."${system}".winapps-launcher
  ];
}
