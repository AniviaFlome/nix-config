{
  pkgs,
  inputs,
  nixvirt,
  username,
  ...
}:
let
  vmStorage = "/var/lib/VM-Storage";
in
{
  imports = [ inputs.nixvirt.nixosModules.default ];

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
    libvirt = {
      enable = true;
      swtpm.enable = true;
      connections."qemu:///system" = {
        domains = [
          {
            definition = nixvirt.lib.domain.writeXML (
              pkgs.lib.recursiveUpdate
                (nixvirt.lib.domain.templates.windows {
                  name = "RDPWindows";
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
                })
                {
                  clock.timer = [
                    {
                      name = "rtc";
                      present = false;
                      tickpolicy = "catchup";
                    }
                    {
                      name = "pit";
                      present = false;
                      tickpolicy = "delay";
                    }
                    {
                      name = "hpet";
                      present = false;
                    }
                    {
                      name = "kvmclock";
                      present = false;
                    }
                    {
                      name = "hypervclock";
                      present = true;
                    }
                  ];
                  features.hyperv = {
                    mode = "custom";
                    relaxed.state = true;
                    vapic.state = true;
                    spinlocks = {
                      state = true;
                      retries = 8191;
                    };
                    vpindex.state = true;
                    synic.state = true;
                    stimer = {
                      state = true;
                      direct.state = true;
                    };
                    reset.state = true;
                    frequencies.state = true;
                    reenlightenment.state = true;
                    tlbflush.state = true;
                    ipi.state = true;
                  };
                  devices.channel = [
                    {
                      type = "unix";
                      source.mode = "bind";
                      target = {
                        type = "virtio";
                        name = "org.qemu.guest_agent.0";
                      };
                      address = {
                        type = "virtio-serial";
                        controller = 0;
                        bus = 0;
                        port = 2;
                      };
                    }
                  ];
                }
            );
          }
        ];
      };
    };
  };

  users.users.${username}.extraGroups = [ "libvirtd" ];

  services.spice-vdagentd.enable = true;

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    winboat
    freerdp
  ];
}
