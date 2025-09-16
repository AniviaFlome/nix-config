{ config, lib, ... }:

with lib;

let
  cfg = config.cachy;
in {
  options.cachy = {
    enable = mkEnableOption "CachyOS tweaks";

    zram = mkOption {
      type = types.enum [ "enable" "disable" ];
      default = "enable";
      description = "Enable or disable ZRAM";
    };

    kernelTweaks = mkOption {
      type = types.bool;
      default = true;
      description = "Enable kernel tweaks for performance";
    };

    udevRules = mkOption {
      type = types.bool;
      default = true;
      description = "Enable udev rules for performance";
    };

    modprobeConfig = mkOption {
      type = types.bool;
      default = true;
      description = "Enable modprobe configuration tweaks";
    };

    systemdTweaks = mkOption {
      type = types.bool;
      default = true;
      description = "Enable systemd tweaks";
    };

    journaldTweaks = mkOption {
      type = types.bool;
      default = true;
      description = "Enable journald tweaks";
    };

    xserverTweaks = mkOption {
      type = types.bool;
      default = true;
      description = "Enable X server tweaks";
    };
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = mkIf cfg.kernelTweaks (mkMerge [
      (mkDefault {
        "vm.swappiness" = 100;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_bytes" = 268435456;
        "vm.page-cluster" = 0;
        "vm.dirty_background_bytes" = 67108864;
        "vm.dirty_writeback_centisecs" = 1500;
        "kernel.nmi_watchdog" = 0;
        "kernel.unprivileged_userns_clone" = 1;
        "kernel.printk" = "3 3 3 3";
        "kernel.kptr_restrict" = 2;
        "kernel.kexec_load_disabled" = 1;
        "net.core.netdev_max_backlog" = 4096;
        "fs.file-max" = 2097152;
      })
    ]);

    services.udev.extraRules = mkIf cfg.udevRules (mkMerge [
      (mkDefault ''
        # Audio permissions
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"

        # SATA Active Link Power Management
        ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", \
            ATTR{link_power_management_policy}=="*", \
            ATTR{link_power_management_policy}="max_performance"

        # HDD
        ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
            ATTR{queue/scheduler}="bfq"

        # SSD
        ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
            ATTR{queue/scheduler}="mq-deadline"

        # NVMe SSD
        ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
            ATTR{queue/scheduler}="none"

        # HDD power management
        ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
            ATTRS{id/bus}=="ata", RUN+="/usr/bin/hdparm -B 254 -S 0 /dev/%k"

        # Enable runtime PM for NVIDIA VGA/3D controller devices on driver bind
        ACTION=="add|bind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
            ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
            TEST=="power/control", ATTR{power/control}="auto"

        # Disable runtime PM for NVIDIA VGA/3D controller devices on driver unbind
        ACTION=="remove|unbind", SUBSYSTEM=="pci", DRIVERS=="nvidia", \
            ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", \
            TEST=="power/control", ATTR{power/control}="on"

        # CPU DMA latency permissions
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

        # Disable power saving for snd-hda-intel unless on battery
        ACTION=="add", SUBSYSTEM=="sound", KERNEL=="card*", DRIVERS=="snd_hda_intel", TEST!="/run/udev/snd-hda-intel-powersave", \
            RUN+="/usr/bin/bash -c 'touch /run/udev/snd-hda-intel-powersave; \
                [[ $(cat /sys/class/power_supply/BAT0/status 2>/dev/null) != "Discharging" ]] && \
                echo $(cat /sys/module/snd_hda_intel/parameters/power_save) > /run/udev/snd-hda-intel-powersave && \
                echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"

        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", TEST=="/sys/module/snd_hda_intel", \
            RUN+="/usr/bin/bash -c 'echo $(cat /run/udev/snd-hda-intel-powersave 2>/dev/null || \
                echo 10) > /sys/module/snd_hda_intel/parameters/power_save'"

        SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", TEST=="/sys/module/snd_hda_intel", \
            RUN+="/usr/bin/bash -c '[[ $(cat /sys/module/snd_hda_intel/parameters/power_save) != 0 ]] && \
                echo $(cat /sys/module/snd_hda_intel/parameters/power_save) > /run/udev/snd-hda-intel-powersave; \
                echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"
      '')
    ]);

    boot.extraModprobeConfig = mkIf cfg.modprobeConfig (mkMerge [
      (mkDefault ''
        # NVIDIA driver tweaks
        options nvidia NVreg_UsePageAttributeTable=1 \
                      NVreg_InitializeSystemMemoryAllocations=0 \
                      NVreg_DynamicPowerManagement=0x02

        # Force AMDGPU on Southern Islands (GCN 1.0) and Sea Islands (GCN 2.0)
        options amdgpu si_support=1 cik_support=1
        options radeon si_support=0 cik_support=0

        # Blacklist watchdog modules
        blacklist iTCO_wdt
        blacklist iTCO_vendor_support
        blacklist sp5100_tco

        # Disable power save for snd_hda_intel
        options snd_hda_intel power_save=0 power_save_controller=N
      '')
    ]);

    boot.kernelParams = mkIf cfg.kernelTweaks (mkMerge [
      (mkDefault [
        "max_ptes_none = 409"
      ])
    ]);

    services.journald.extraConfig = mkIf cfg.journaldTweaks (mkMerge [
      (mkDefault ''
        SystemMaxUse=50M
      '')
    ]);

    services.xserver = mkIf cfg.xserverTweaks {
      config = mkMerge [
        (mkDefault ''
        Section "InputClass"
            Identifier "libinput touchpad catchall"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Driver "libinput"
            Option "Tapping" "True"
        EndSection
      '')
      ];
    };

    systemd.settings.Manager = mkIf cfg.systemdTweaks (mkMerge [
      (mkDefault {
        DefaultTimeoutStartSec = "15s";
        DefaultTimeoutStopSec = "10s";
      })
    ]);
  };
}