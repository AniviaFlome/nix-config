# CachyOS Tweaks Flake

A Nix flake that provides performance tweaks inspired by CachyOS, packaged as a reusable NixOS module.

## Features

This flake provides a NixOS module that enables various system optimizations for better performance, including:

- Kernel sysctl tweaks for memory management
- Udev rules for storage and audio devices
- Modprobe configuration for GPU drivers
- Systemd timeout optimizations
- Journald configuration tweaks
- X server input device configuration

## Usage

### Adding to your flake inputs

```nix
{
  inputs = {
    cachy-tweaks = {
      url = "github:your-username/cachy-tweaks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, cachy-tweaks, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        cachy-tweaks.nixosModules.cachy-tweaks
      ];
    };
  };
}
```

### Enabling the module

In your NixOS configuration:

```nix
{ config, ... }:

{
  cachy.enable = true;
  
  # You can customize individual components:
  # cachy.zram = "disable";
  # cachy.kernelTweaks = false;
  # cachy.udevRules = false;
  # etc.
}
```

## Options

The module provides the following options under `cachy.*`:

- `enable`: Enable all CachyOS tweaks (default: false)
- `zram`: Enable or disable ZRAM ("enable" or "disable", default: "enable")
- `kernelTweaks`: Enable kernel tweaks for performance (default: true)
- `udevRules`: Enable udev rules for performance (default: true)
- `modprobeConfig`: Enable modprobe configuration tweaks (default: true)
- `systemdTweaks`: Enable systemd tweaks (default: true)
- `journaldTweaks`: Enable journald tweaks (default: true)
- `xserverTweaks`: Enable X server tweaks (default: true)

## License

MIT