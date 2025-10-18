{
  inputs,
  pkgs,
  system,
  username,
  ...
}:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      package = with pkgs.stable; libvirt;
      qemu = {
        package = with pkgs.stable; qemu;
        swtpm = {
          enable = false;
          package = with pkgs.stable; swtpm;
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.users.${username}.extraGroups = [ "libvirtd" ];
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = [
    inputs.winboat.packages.${system}.winboat
    pkgs.freerdp
  ];
}
