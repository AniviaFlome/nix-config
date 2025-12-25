{
  config,
  inputs,
  nixvirt,
  ...
}:
let
  vmStorage = "${config.home.homeDirectory}/VM-Storage";
in
{
  imports = [ inputs.nixvirt.homeModules.default ];

  virtualisation.libvirt = {
    enable = true;
    swtpm.enable = true;
    connections."qemu:///session" = {
      domains = [
        {
          definition = nixvirt.lib.domain.writeXML (
            nixvirt.lib.domain.templates.windows {
              name = "Windows-Main";
              uuid = "fdc2039f-17f3-43c9-8f61-51a56ac48696";
              memory = {
                count = 8;
                unit = "GiB";
              };
              storage_vol = {
                pool = "MyPool";
                volume = "Windows-Main.qcow2";
              };
              backing_vol = null;
              nvram_path = "${vmStorage}/Windows-Main.nvram";
              install_vol = "${vmStorage}/Win11.iso";
              bridge_name = "virbr0";
              virtio_net = true;
              virtio_drive = true;
              install_virtio = true;
            }
          );
        }
      ];
    };
  };
}
